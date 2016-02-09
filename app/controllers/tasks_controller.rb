class TasksController < ApplicationController

  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?


  # POST /tasks
  # POST /tasks.json
  def create


    @task = Task.new(task_params)
    @task.policy_type.capitalize!

    respond_to do |format|
      if @task.save
        format.json { render json: @task, status: :created }
      else

        format.json { render json: @task.errors, status: :unprocessable_entity }

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
    @traffic = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:policy_id, :policy_type, :label, :state, :time)
  end
end
