require_relative "communication"
require_relative "parameter"

module Publication



  def publish(policy)
    begin
      parameters = Parameter.new(__FILE__)

    rescue Exception => e
        raise e.message

    else
      scraperbot_host = parameters.scraperbot_host
      scraperbot_port = parameters.scraperbot_port
      enginebot_host = parameters.enginebot_host
      enginebot_port = parameters.enginebot_port
      begin
        send_to_calendar("save",
                         policy[:scraperbot][:policy_type],
                         policy[:scraperbot],
                         scraperbot_host, scraperbot_port)

      rescue Exception => e
        # impossible de publier la policy vers scraperbot
        raise "No connection could be made because the target machine : scraperbot actively refused it on #{scraperbot_host}:#{scraperbot_port}"
      else

        begin
          send_to_calendar("save",
                           policy[:enginebot][:policy_type],
                           policy[:enginebot],
                           enginebot_host, enginebot_port)

        rescue Exception => e
          # impossible de publier la policy vers engine bot
          # alors on essaie d'annuler la publication faite vers scraperbot
          begin
            send_to_calendar("delete",
                             policy[:scraperbot][:policy_type],
                             policy[:scraperbot],
                             scraperbot_host, scraperbot_port)

          rescue Exception => e
            #l'annulation a échoué
            # il faut alerte qu'il y a incsistance entre scraperbot et enginebot
            raise "scraperbot and enginebot are unconsistant"
          else
            raise "No connection could be made because the target machine : enginebot actively refused it on #{enginebot_host}:#{enginebot_port}"
          end
        else
        end
      end
    end
  end

  private

  def send_to_calendar(action, object, data, where_ip, where_port)
    @query = {"cmd" => action}
    @query.merge!({"object" => object})
    @query.merge!({"data" => data})

    begin
      Information.new(@query).send_to(where_ip, where_port)
    rescue Exception => e
      $stderr << e.message
      raise e.message
    end
  end


  module_function :publish
  module_function :send_to_calendar
end