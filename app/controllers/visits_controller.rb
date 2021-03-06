require_relative '../../lib/scheduler'
require 'maxminddb'

class VisitsController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_visit, only: [:show]
  before_action :select_visits, only: [:index, :refresh, :delete_all_by_state]


  def index
#ne pas supprimer
  end

  def refresh
#ne pas supprimer
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @visit = Visit.find_by_id_visit(params[:id_visit])

    if @visit.nil?
      @visit = Visit.new(visit_params)

      if @visit.policy_type == "seaattack"
        @visit.policy_type = "SeaAttack"
      else
        @visit.policy_type.capitalize!
      end


      respond_to do |format|
        if @visit.save
          format.json { render json: @visit, status: :created }

        else
          format.json { render json: @visit.errors, status: :unprocessable_entity }

        end
      end
    else
      if @visit.update_attribute(:state, visit_params[:state])
        format.json { render json: @visit, status: :created }

      else
        format.json { render json: @visit.errors, status: :unprocessable_entity }

      end
    end
  end

  # DELETE /traffics/1
  # DELETE /traffics/1.json
  def delete
    begin
      @visit = Visit.find_by_id_visit(params[:visit_id])
      @visit.destroy!

    rescue Exception => e
      @alert = "Visit #{params['visit_id']} not delete : #{e.message}"

    else
      @notice = "Visit #{params['visit_id']}  delete"

    ensure
      select_visits

      render :index
    end
  end

  def delete_all_by_state
    begin
      @visits.each { |visit| visit.destroy! }

    rescue Exception => e
      @alert = "Visits not delete : #{e.message}"

    else
      @notice = "All Visits delete"

    ensure
      select_visits

      render :index
    end
  end

  def browsed_page
    @visit = Visit.find_by_id_visit(params[:visit_id])

    respond_to do |format|
      if @visit.nil?
        format.json { render json: @visit, status: :not_found }

      else
        begin
          @visit.update_attributes!({:count_browsed_page =>params[:index],
                                     :actions => visit_params[:actions]})
        rescue Exception => e
          logger.debug e.message
          format.json { render json: @visit.errors, status: :unprocessable_entity }
        else
          format.json { render json: @visit, status: :created }

        end
      end
    end
  end

  def log
    render :file => @visit.log.log_file_id
  end


  def publish
    begin
      Scheduler::publish(params['visit_id'])

    rescue Exception => e
      @alert = "Scheduler not start execution visit #{params['visit_id']} : #{e.message}"
    else
      @notice = "Scheduler start execution visit #{params['visit_id']}"
    ensure
      select_visits

      render :index
    end
  end

  def publish_all
    begin
      @visits = Visit.where({:policy_id => params[:policy_id],
                             :policy_type => params[:policy_type],
                             :state => params[:state]})
      @visits.each { |visit| Scheduler::publish(visit.id_visit) }

    rescue Exception => e
      @alert = "Scheduler not start execution visit  : #{e.message}"
    else
      @notice = "Scheduler start execution visit}"
    ensure
      select_visits

      render :index
    end
  end

  def restart
    #demande une nouvelle execution de la visit aupres du scheduler
    begin
      #suppression de la log, des captchas, et pages en relation avec l'execution pass�e de la visit
      @visit = Visit.find_by_id_visit(params[:visit_id])
      @visit.pages.destroy_all
      @visit.log.destroy!
      @visit.captchas.destroy_all
      #initialisation du nombre de page vu
      @visit.update_attribute(:count_browsed_page, -1)

      # execution du restart
      Scheduler::restart(params['visit_id'])

    rescue Exception => e
      @alert = "Scheduler not start execution visit #{params['visit_id']} : #{e.message}"
    else
      @notice = "Scheduler start execution visit #{params['visit_id']}"
    ensure
      select_visits

      render :index
    end
  end

  def started
    @visit = Visit.find_by_id_visit(params[:visit_id])

    respond_to do |format|
      if @visit.nil?
        format.json { render json: @visit, status: :not_found }

      elsif @visit.update_attributes({:start_time => Time.now,
                                      :actions => visit_params[:actions],
                                      :ip_geo_proxy => visit_params[:ip_geo_proxy],
                                      :state => "started",
                                      :country_geo_proxy => GeoIp.ip_to_country(visit_params[:ip_geo_proxy])})
        format.json { render json: @visit, status: :created }

      else
        format.json { render json: @visit.errors, status: :unprocessable_entity }

      end
    end
  end

  def update
    @visit = Visit.find_by_id_visit(params[:id])


    case visit_params[:state]
      when "fail", "advertnotfound"
        datas = {:state => visit_params[:state],
                 :reason => visit_params[:reason],
                 :end_time => Time.now}

      when "success", "overttl"
        datas = {:state => visit_params[:state],
                 :end_time => Time.now}

      else
        datas = {:state => visit_params[:state]}

    end

    respond_to do |format|
      if @visit.nil?
        format.json { render json: @visit, status: :not_found }

      elsif @visit.update_attributes(datas)
        format.json { render json: @visit, status: :created }

      else
        format.json { render json: @visit.errors, status: :unprocessable_entity }

      end
    end
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visit
    @visit = Visit.find(params[:id])
  end

  def select_visits
    @policy_id = params['policy_id']
    @policy_type = params['policy_type']
    page_index = params[:page] || 1
    @state = params[:state] || "created"

    case @state
      when "created", "scheduled", "published", "neverstarted"
        order_by = "date(plan_time) desc, #{params[:criteria] || "plan_time"} #{params[:way] || "desc"}"

      when "started"
        order_by = "date(start_time) desc, #{params[:criteria] || "start_time"} #{params[:way] || "desc"}"

      when "success", "fail", "outoftime", "overttl", "advertnotfound"
        order_by = "date(end_time) desc, #{params[:criteria] || "end_time"} #{params[:way] || "desc"}"

    end


    if !@policy_type.nil? and !@policy_id.nil?
      @visits = Visit.where({:policy_id => @policy_id,
                             :policy_type => @policy_type,
                             :state => @state}).order(order_by).page(page_index)
    elsif !@policy_type.nil?
      @visits = Visit.where({:policy_type => @policy_type,
                             :state => @state}).order(order_by).page(page_index)
    elsif !@policy_id.nil?

      @visits = Visit.where({:policy_id => @policy_id,
                             :state => @state}).order(order_by).page(page_index)
    else
      @visits = Visit.where({:state => @state}).order(order_by).page(page_index)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visit_params
    params.require(:visit).permit(:policy_id,
                                  :policy_type,
                                  :id_visit,
                                  :execution_mode,
                                  :plan_time,
                                  :start_time,
                                  :end_time,
                                  :landing_url,
                                  :referrer,
                                  :advert,
                                  :state,
                                  :browser_name,
                                  :browser_version,
                                  :operating_system_name,
                                  :operating_system_version,
                                  :count_browsed_page,
                                  :ip_geo_proxy,
                                  :country_geo_proxy,
                                  :reason,
                                  :keywords,
                                  :actions => []) #car durations est un array
  end
end
