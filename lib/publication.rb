require_relative "communication"
require_relative "parameter"
require 'rest-client'
require 'json'

module Publication
  def sea(policy_id, keywords, label_advertisings)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin
        # http://localhost:9104/policies/seaattack/?policy_id=#{policyid}
        response = RestClient.patch "http://#{enginebot_host}:#{enginebot_port}/policies/seaattack/?policy_id=#{policy_id}",
                                    JSON.generate({:keywords => keywords,
                                                   :label_advertisings => label_advertisings}),
                                    :content_type => :json,
                                    :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not update labels advertisings seaattack #{policy_id} on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

  def execution_mode(policy_type, policy_id, execution_mode)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port

      begin
        # http://localhost:9104/policies/seaattack/?execution_mode=[manual|auto]&policy_id=#{policy_id}
        response = RestClient.patch "http://#{enginebot_host}:#{enginebot_port}/policies/#{policy_type}/?execution_mode=#{execution_mode}&policy_id=#{policy_id}",
                                    :content_type => :json,
                                    :accept => :json


      rescue Exception => e
        # impossible de demander le demarrage la tache vers engine bot
        raise e.message

      else
        raise "not update execution mode #{policy_type} #{policy_id} on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

  def start(task_label, event_id)
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
        raise "not start task #{task_label} #{event_id} on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

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
        raise e.message

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
        raise e.message

      else
        raise "not delete policy on enginebot calendar (#{enginebot_host}:#{enginebot_port}) : #{response}" if response.code != 200
        response
      end
    end
  end

  def host
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      parameters.enginebot_host
    end
  end

  def port
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else

      parameters.enginebot_port

    end
  end

  private
  module_function :sea
  module_function :execution_mode
  module_function :publish
  module_function :delete
  module_function :host
  module_function :port
  module_function :start
end