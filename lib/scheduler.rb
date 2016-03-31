require_relative "parameter"
require 'rest-client'
require 'json'

module Scheduler


  def publish(visit_id)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin
        #http://localhost:9104/tasks/id?task_id=#{task_id}
        response = RestClient.put "http://#{enginebot_host}:#{enginebot_port}/visits/published/?visit_id=#{visit_id}",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not published visit #{visit_id} to scheduler (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200

      end
    end
  end


  private



  private

  module_function :publish

end