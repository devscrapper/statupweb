require_relative "communication"
require_relative "parameter"
require 'addressable/uri'
require 'rest-client'
require 'json'

module ExternUri

  def count_keywords(hostname)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
      raise e.message

    else
      saas_keyword_host = parameters.saas_keyword_host
      saas_keyword_port = parameters.saas_keyword_port


      begin
        hostname = Addressable::URI.parse(hostname).hostname

        #http://localhost:9251/?action=count&hostname=www.epilation-laser-definitive.info
        response = RestClient.get "http://#{saas_keyword_host}:#{saas_keyword_port}/?action=count&hostname=#{hostname}",
                                  :content_type => :json,
                                  :accept => :json


      rescue Exception => e
        raise "not get count keyword for hostname #{hostname} (#{saas_keyword_host}:#{saas_keyword_port}) :  #{e.message} "

      else
        raise "not get count keyword for hostname #{hostname}  (#{saas_keyword_host}:#{saas_keyword_port}) : #{response}" if response.code != 200
        p response
        JSON.parse(response)["count"]

      end
    end
  end
  def count_referral(policy_id, policy_type)
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


  module_function :count_keywords
  module_function :count_referral

end