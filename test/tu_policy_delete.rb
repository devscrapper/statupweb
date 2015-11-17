require_relative "../lib/communication"

def send_to_calendar(object, data, where_ip, where_port)

  @query = {"cmd" => "delete"}
  @query.merge!({"object" => object})
  @query.merge!({"data" => data})

  begin
    Information.new(@query).send_to(where_ip, where_port)
  rescue Exception => e
    $stderr << e.message
  end
end


SCRAPERBOT_HOST = "localhost"
SCRAPERBOT_PORT = 9154
ENGINEBOT_HOST = "localhost"
ENGINEBOT_PORT = 9104

datas = [
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 1, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-ga"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {
         :policy_id => 1, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-ga"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 2, :policy_type => "Rank", :website_label => "epilation-laser-definitive-ga"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 2, :policy_type => "Rank", :website_label => "epilation-laser-definitive-ga"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 3, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-default"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 3, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-default"}
    },


    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 4, :policy_type => "Rank", :website_label => "epilation-laser-definitive-default"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 4, :policy_type => "Rank", :website_label => "epilation-laser-definitive-default"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 5, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-custom"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 5, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-custom"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 6, :policy_type => "Rank", :website_label => "epilation-laser-definitive-custom"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 6, :policy_type => "Rank", :website_label => "epilation-laser-definitive-custom"}
    }

]


datas.each { |data|
  policy = data[:data]


  case data[:destination]
    when :scraperbot
      #-----------------------------------------------------------------------------------------------------------------------
      # POLICY SEND TO SCRAPERBOT
      #-----------------------------------------------------------------------------------------------------------------------
      send_to_calendar(policy[:policy_type], policy, SCRAPERBOT_HOST, SCRAPERBOT_PORT)
    #-----------------------------------------------------------------------------------------------------------------------
    # POLICY SEND TO ENGINEBOT
    #-----------------------------------------------------------------------------------------------------------------------
    when :enginebot

      send_to_calendar(policy[:policy_type], policy, ENGINEBOT_HOST, ENGINEBOT_PORT)
  end
}

