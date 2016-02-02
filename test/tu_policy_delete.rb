require_relative "../lib/publication"


datas = [

    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {
         :policy_id => 1, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-ga"}
    },

    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 2, :policy_type => "Rank", :website_label => "epilation-laser-definitive-ga"}
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 3, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-default"}
    },

    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 4, :policy_type => "Rank", :website_label => "epilation-laser-definitive-default"}
    },

    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 5, :policy_type => "Traffic", :website_label => "epilation-laser-definitive-custom"}
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

  $environement = "development"
 # $environement = "test"

  begin
    tasks = Publication.delete(policy[:policy_id])
  rescue Exception => e
      p "policy #{policy[:policy_id]}/#{policy[:policy_type]}/#{policy[:website_label]} not delete : #{e.message}"
  else
    p "policy #{policy[:policy_id]}/#{policy[:policy_type]}/#{policy[:website_label]} delete"
    p "tasks #{tasks}"
  end
}

