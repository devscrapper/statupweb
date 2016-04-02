require_relative '../../lib/scheduler'

class VisitsController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    @visits = Visit.where({:policy_id => params[:policy_id]})
    @policy_id = params['policy_id']
  end
  def refresh
    @visits = Visit.where({:policy_id => params[:policy_id]})
    @policy_id = params['policy_id']
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @visit = Visit.find_by_id_visit(params[:id_visit])

    if @visit.nil?
      @visit = Visit.new(visit_params)

      @visit.policy_type.capitalize!

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


  def publish
    begin
      Scheduler::publish(params['visit_id'])

    rescue Exception => e
      @alert = "Scheduler not start execution visit #{params['visit_id']} : #{e.message}"
    else
      @notice = "Scheduler start execution visit #{params['visit_id']}"
    ensure
      @visits = Visit.where(:policy_id => params[:policy_id])
      @policy_id = params['policy_id']
    end
  end

  def update
    @visit = Visit.find_by_id_visit(params[:id])

    respond_to do |format|
      if @visit.nil?
        format.json { render json: @visit, status: :not_found }

      elsif @visit.update_attribute(:state, visit_params[:state])
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
                                  :start_time,
                                  :landing_url,
                                  :referrer,
                                  :advert,
                                  :state,
                                  :browser_name,
                                  :browser_version,
                                  :operating_system_name,
                                  :operating_system_version,
                                  :durations => []) #car durations est un array
  end
end
