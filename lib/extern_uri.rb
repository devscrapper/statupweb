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

        JSON.parse(response)["count"]

      end
    end
  end
  def count_backlinks(hostname)
    begin
        parameters = Parameter.new(__FILE__)

      rescue Exception => e
        raise e.message

      else
        saas_backlink_host = parameters.saas_backlink_host
        saas_backlink_port = parameters.saas_backlink_port


        begin
          hostname = Addressable::URI.parse(hostname).hostname

          #http://localhost:9252/?action=count&hostname=www.epilation-laser-definitive.info
          response = RestClient.get "http://#{saas_backlink_host}:#{saas_backlink_port}/?action=count&hostname=#{hostname}",
                                    :content_type => :json,
                                    :accept => :json


        rescue Exception => e
          raise "not get count backlinks for hostname #{hostname} (#{saas_backlink_host}:#{saas_backlink_port}) :  #{e.message} "

        else
          raise "not get count backlinks for hostname #{hostname}  (#{saas_backlink_host}:#{saas_backlink_port}) : #{response}" if response.code != 200

          JSON.parse(response)["count"]

        end
      end
  end


  private


  module_function :count_keywords
  module_function :count_backlinks

end