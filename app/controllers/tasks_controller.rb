class TasksController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?


  # POST /tasks
  # POST /tasks.json
  def create
    #TODO pour eviter les doublon lors des relance manuelles par exemple à partir du calendar, prevoir de controler que
    #TODO la tache est absente pour la creer et sinon de la maj ou de la supprimer.
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

  def update
    @task = Task.find_by_task_id(params[:id])


    respond_to do |format|
      if @task.nil?
        format.json { render json: @task, status: :not_found }

      else
        case task_params[:state]
          when "over"
            ok = @task.update_attributes({:state => task_params[:state],
                                          :finish_time => task_params[:finish_time]})
          when "fail"
            ok = @task.update_attributes({:state => task_params[:state],
                                          :finish_time => task_params[:finish_time],
                                          :error_label => task_params[:error_label]})
        end
        if ok
          format.json { render json: @task, status: :created }

        else
          format.json { render json: @task.errors, status: :unprocessable_entity }

        end
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
    params.require(:task).permit(:policy_id,
                                 :policy_type,
                                 :label,
                                 :state,
                                 :time,
                                 :building_date,
                                 :finish_time,
                                 :task_id,
                                 :error_label)
  end
end
