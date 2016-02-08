require_relative "communication"
require_relative "parameter"
require 'rest-client'
require 'json'

module ExternUri

  def objectives_of_policy(policy_id, policy_type)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin

        #http://localhost:9104/objectives/all/?policy_id=20&policy_type=traffic
        response = RestClient.get "http://#{enginebot_host}:#{enginebot_port}/objectives/all", :params => {:policy_id => policy_id, :policy_type => policy_type} ,
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de recuprer les task d'une policy
        raise "not get policy tasks on enginebot calendar (#{enginebot_host}:#{enginebot_port}) :  #{e.message} "

      else
        raise "not get policy tasks on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end
  def tasks_of_policy(policy_id, policy_type)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin


        response = RestClient.get "http://#{enginebot_host}:#{enginebot_port}/tasks/all",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        # impossible de recuprer les task d'une policy
        raise "not get policy tasks on enginebot calendar (#{enginebot_host}:#{enginebot_port}) :  #{e.message} "

      else
        raise "not get policy tasks on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end


  private


  module_function :tasks_of_policy
  module_function :objectives_of_policy

end