class VisitsController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?


  # POST /tasks
  # POST /tasks.json
  def create
    @visit = Visit.new(visit_params)

    @visit.policy_type.capitalize!
    respond_to do |format|
      if @visit.save
        format.json { render json: @visit, status: :created }
      else

        format.json { render json: @visit.errors, status: :unprocessable_entity }

      end
    end
  end

  def update
    @visit = Visit.find_by_id_visit(params[:id])


    respond_to do |format|
      if @visit.update_attribute(:state, visit_params[:state])
        format.json { render json: @visit, status: :updated }
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
                                  :start_time,
                                  :landing_url,
                                  :referrer,
                                  :advert,
                                  :state,
                                  :durations => []) #car durations est un array
  end
end
