class ObjectivesController < ApplicationController
  protect_from_forgery
   skip_before_action :verify_authenticity_token, if: :json_request?
 
 
   # POST /tasks
   # POST /tasks.json
   def create
     @objective = Objective.new(objective_params)


     if @objective.policy_type == "seaattack"
       @objective.policy_type = "SeaAttack"
     else
       @objective.policy_type.capitalize!
     end
     respond_to do |format|
       if @objective.save
         format.json { render json: @objective, status: :created }
       else
 
         format.json { render json: @objective.errors, status: :unprocessable_entity }
 
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
     @objective = Objective.find(params[:id])
   end
 
   # Never trust parameters from the scary internet, only allow the white list through.
   def objective_params
     params.require(:objective).permit(:policy_id, :policy_type, :count_visits, :visit_bounce_rate, :avg_time_on_site, :page_views_per_visit,:hourly_distribution, :day)
   end
end
