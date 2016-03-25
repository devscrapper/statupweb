require_relative "parameter"
require 'rest-client'
require 'json'

module Calendar

  class Task

    attr_reader :id,
                :label,
                :state,
                :pre_tasks,
                :execution_mode

    def initialize(task)
      @id = task['id']
      @label = task['label']
      @state = task['state']
      @pre_tasks = task['pre_tasks']
      @execution_mode = task['execution_mode']
    end
  end

  def get_task(event_id)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin
        #http://localhost:9104/tasks/id?task_id=#{task_id}
        response = RestClient.get "http://#{enginebot_host}:#{enginebot_port}/tasks/id/?task_id=#{event_id}",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not get task #{event_id} from enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        Task.new(JSON.parse(response))
      end
    end
  end

  def execute_task(task_label, event_id)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin

        response = RestClient.get "http://#{enginebot_host}:#{enginebot_port}/tasks/execute/?id=#{event_id}",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not execute task #{task_label} #{event_id} on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        JSON.parse(response).map { |task| Task.new(task) }
      end
    end
  end

  def current_date(date, policy_id, policy_type)
    tasks_of_day(Date.parse(date), policy_id, policy_type)
  end

  def today(policy_id, policy_type)
    tasks_of_day(Date.today, policy_id, policy_type)
  end

  def next_day(date, policy_id, policy_type)
    tasks_of_day(Date.parse(date).next_day, policy_id, policy_type)
  end

  def prev_day(date, policy_id, policy_type)
    tasks_of_day(Date.parse(date).prev_day, policy_id, policy_type)
  end

  private
  def tasks_of_day(date, policy_id, policy_type)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin
        #http://localhost:9104/tasks/date/?date=#{date}&policy_type=#{policy_type}&policy_id=#{policy_id}
        response = RestClient.get "http://#{enginebot_host}:#{enginebot_port}/tasks/date/?date=#{date}&policy_type=#{policy_type}&policy_id=#{policy_id}&task_label=true",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not get task of day #{date} of policy #{policy_type} #{policy_id} on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        JSON.parse(response).map { |task|
          Task.new(task)
        }
      end
    end
  end


  private

  module_function :get_task
  module_function :current_date
  module_function :today
  module_function :next_day
  module_function :prev_day
  module_function :tasks_of_day
  module_function :execute_task
end