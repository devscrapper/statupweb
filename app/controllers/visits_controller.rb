require_relative '../../lib/scheduler'
require 'maxminddb'
class VisitsController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    if !params[:state].nil?
      case params[:state]
        when "created", "scheduled", "published", "outoftime", "neverstarted"
          order_by = "plan_time asc"

        when "success", "fail", "overttl"
          order_by = "end_time desc"

      end
    else
      order_by = "plan_time asc"
    end

    @visits = Visit.where({:policy_id => params[:policy_id],
                           :policy_type => params[:policy_type],
                           :state => params[:state] || "created"}).order(order_by)
    @policy_id = params['policy_id']
    @policy_type = params['policy_type']
    @execution_mode = params['execution_mode']
    @state = params[:state] || "created"
  end

  def refresh
    @visits = Visit.where({:policy_id => params[:policy_id],
                           :policy_type => params[:policy_type],
                           :state => params[:state]}).order("start_time desc")
    @policy_id = params['policy_id']
    @policy_type = params['policy_type']
    @execution_mode = params['execution_mode']
    @state = params[:state]
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
      @visits = Visit.where({:policy_id => params[:policy_id],
                             :policy_type => params[:policy_type],
                             :state => params[:state]}).order("start_time desc")
      @policy_id = params['policy_id']
      @policy_type = params['policy_type']
      @execution_mode = params['execution_mode']
      @state = params[:state]
    end
  end

  def delete_all_by_state
    begin
      @visits = Visit.where({:policy_id => params[:policy_id],
                             :policy_type => params[:policy_type],
                             :state => params[:state]})
      @visits.each { |visit| visit.destroy! }
    rescue Exception => e
      @alert = "Visits not delete : #{e.message}"
    else
      @notice = "All Visits delete"
    ensure
      @visits = Visit.where({:policy_id => params[:policy_id],
                             :policy_type => params[:policy_type],
                             :state => params[:state]}).order("start_time desc")
      @policy_id = params['policy_id']
      @policy_type = params['policy_type']
      @execution_mode = params['execution_mode']
      @state = params[:state]
    end
  end

  def browsed_page
    @visit = Visit.find_by_id_visit(params[:visit_id])

    respond_to do |format|
      if @visit.nil?
        format.json { render json: @visit, status: :not_found }

      elsif @visit.update_attribute(:count_browsed_page, @visit.count_browsed_page + 1)
        format.json { render json: @visit, status: :created }

      else
        format.json { render json: @visit.errors, status: :unprocessable_entity }

      end
    end
  end

  def order_by
    @visits = Visit.where({:policy_id => params[:policy_id],
                           :policy_type => params[:policy_type],
                           :state => params[:state]}).order("date(plan_time) desc, #{params[:criteria].to_s || "start_time"} #{params[:way] || "desc"}")
    @policy_id = params['policy_id']
    @policy_type = params['policy_type']
    @execution_mode = params['execution_mode']
    @state = params[:state]
  end

  def publish
    begin
      Scheduler::publish(params['visit_id'])

    rescue Exception => e
      @alert = "Scheduler not start execution visit #{params['visit_id']} : #{e.message}"
    else
      @notice = "Scheduler start execution visit #{params['visit_id']}"
    ensure
      @visits = Visit.where({:policy_id => params[:policy_id], :state => params[:state]}).order("start_time desc")
      @policy_id = params['policy_id']
      @policy_type = params['policy_type']
      @execution_mode = params['execution_mode']
      @state = params[:state]
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
      @visits = Visit.where({:policy_id => params[:policy_id],
                             :policy_type => params[:policy_type],
                             :state => params[:state]}).order("start_time desc")
      @policy_id = params['policy_id']
      @policy_type = params['policy_type']
      @execution_mode = params['execution_mode']
      @state = params[:state]
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
      when "fail"
        datas = {:state => visit_params[:state],
                 :reason => visit_params[:reason],
                 :end_time => Time.now}

      when "success",  "overttl"
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
  def set_traffic
    @visit = Visit.find(params[:id])
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
                                  :actions => []) #car durations est un array
  end
end
