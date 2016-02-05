require_relative "communication"
require_relative "parameter"
require 'rest-client'
require 'json'

module Publication


  def publish(policy)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin

        response = RestClient.post "http://#{enginebot_host}:#{enginebot_port}/policies/#{policy[:policy_type]}",
                                   JSON.generate(policy),
                                   :content_type => :json,
                                   :accept => :json


      rescue Exception => e
        # impossible de publier la policy vers engine bot
        raise "not save policy on enginebot calendar (#{enginebot_host}:#{enginebot_port}) :  #{e.message} "

      else
        raise "not save policy on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

  def delete(policy_id, policy_type)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin

        response = RestClient.delete "http://#{enginebot_host}:#{enginebot_port}/#{policy_type.pluralize}/#{policy_id}",
                                     :content_type => :json,
                                     :accept => :json

      rescue Exception => e
        # impossible de publier la policy vers engine bot
        raise "not delete policy on enginebot calendar (#{enginebot_host}:#{enginebot_port}) :  #{e.message}"

      else
        raise "not delete policy on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

  private


  module_function :publish
  module_function :delete
end