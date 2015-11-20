# encoding: UTF-8
require_relative "../lib/communication"
require_relative "../lib/publication"

def send_to_calendar(object, data, where_ip, where_port)

  @query = {"cmd" => "save"}
  @query.merge!({"object" => object})
  @query.merge!({"data" => data})

  begin
    response = Question.new(@query).ask_to(where_ip, where_port)

  rescue Exception => e
    $stderr << e.message
  else
    raise response[:error] if response[:state] == :ko
    response[:data] if response[:state] == :ok and !response[:data].nil?
  end
end

def next_monday(date)
  today = Date.parse(date) if date.is_a?(String)
  today = date if date.is_a?(Date)

  return today.next_day(1) if today.sunday?
  return today.next_day(2) if today.saturday?
  return today.next_day(3) if today.friday?
  return today.next_day(4) if today.thursday?
  return today.next_day(5) if today.wednesday?
  return today.next_day(6) if today.tuesday?
  return today.next_day(7) if today.monday?
end

SCRAPERBOT_HOST = "localhost"
ENGINEBOT_HOST = "localhost"

# SCRAPERBOT_HOST = "192.168.1.85"
# ENGINEBOT_HOST = "192.168.1.85"

SCRAPERBOT_PORT = 9154
ENGINEBOT_PORT = 9104

MIN_COUNT_PAGE_ADVERTISER = 10 # nombre de page min consultées chez l'advertiser : fourni par statupweb
MAX_COUNT_PAGE_ADVERTISER = 15 # nombre de page max consultées chez l'advertiser : fourni par statupweb

MIN_DURATION_PAGE_ADVERTISER = 60 # durée de lecture min d'une page max consultées chez l'advertiser : fourni par statupweb
MAX_DURATION_PAGE_ADVERTISER = 120 # durée de lecture max d'une page max consultées chez l'advertiser : fourni par statupweb

PERCENT_LOCAL_PAGE_ADVERTISER = 80 # pourcentage de page consultées localement à l'advertiser fournit par statupweb

DURATION_REFERRAL = 20 # durée de lecture du referral : fourni par statupweb

MIN_COUNT_PAGE_ORGANIC = 4 #nombre min de page de resultat du moteur de recherche consultées : fourni par statupweb
MAX_COUNT_PAGE_ORGANIC = 6 #nombre min de page de resultat du moteur de recherche consultées : fourni par statupweb

MIN_DURATION_PAGE_ORGANIC = 10 #durée de lecture min d'une page de resultat fourni par le moteur de recherche : fourni par statupweb
MAX_DURATION_PAGE_ORGANIC = 30 #durée de lecture max d'une page de resultat fourni par le moteur de recherche : fourni par statupweb

MIN_DURATION_SURF = 5 # temps en seconde min de lecture d'une page d'un site consulté avant d'atterrir sur le website
MAX_DURATION_SURF = 10 # temps en seconde min de lecture d'une page d'un site consulté avant d'atterrir sur le website

MIN_DURATION_WEBSITE = 10 #temps en seconde min de lecture d'une page du website

MIN_PAGES_WEBSITE = 2 #nombre min de page consulter sur le website

MAX_DURATION_SCRAPING = 1 # nombre de jour allouer au scraping de website et organic pour policy traffic


# parameter utiliser par engine bot
param_enginebot = {
    :min_count_page_advertiser => MIN_COUNT_PAGE_ADVERTISER,
    :max_count_page_advertiser => MAX_COUNT_PAGE_ADVERTISER,
    :min_duration_page_advertiser => MIN_DURATION_PAGE_ADVERTISER,
    :max_duration_page_advertiser => MAX_DURATION_PAGE_ADVERTISER,
    :percent_local_page_advertiser => PERCENT_LOCAL_PAGE_ADVERTISER,
    :duration_referral => DURATION_REFERRAL,
    :min_count_page_organic => MIN_COUNT_PAGE_ORGANIC,
    :max_count_page_organic => MAX_COUNT_PAGE_ORGANIC,
    :min_duration_page_organic => MIN_DURATION_PAGE_ORGANIC,
    :max_duration_page_organic => MAX_DURATION_PAGE_ORGANIC,
    :min_duration => MIN_DURATION_SURF,
    :max_duration => MAX_DURATION_SURF,
    :min_duration_website => MIN_DURATION_WEBSITE,
    :min_pages_website => MIN_PAGES_WEBSITE
}
datas = [
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :scraperbot,
    #  :data => {:policy_id => 1, :policy_type => "Traffic", :website_id => 1, :website_label => "épilation-laser-definitive-ga", :statistics_type => :ga,
    #            :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), # +7  #à cause de la policy Traffic (scraping website & organic)
    #            :count_weeks => 12,
    #            :profil_id_ga => "123456", # à cause de l'option de statistique = :ga
    #            :url_root => "http://www.epilation-laser-definitive.info/",
    #            :count_page => 0, #à cause de la policy Traffic
    #            :schemes => "http", #à cause de la policy Traffic
    #            :types => "global", #à cause de la policy Traffic
    #            :max_duration_scraping => MAX_DURATION_SCRAPING # +7  #à cause de la policy Traffic (scraping website & organic)
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :enginebot,
    #  :data => {
    #      :policy_id => 1, :policy_type => "Traffic", :website_id => 1, :website_label => "epilation-laser-definitive-ga",
    #      :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), # +7  #à cause de la policy Traffic (scraping website & organic)
    #      :count_weeks => 4,
    #      :url_root => "http://www.epilation-laser-definitive.info/",
    #      :change_count_visits_percent => 10, #à cause de la policy Traffic
    #      :change_bounce_visits_percent => 1, #à cause de la policy Traffic
    #      :direct_medium_percent => 10, #à cause de la policy Traffic
    #      :organic_medium_percent => 80, #à cause de la policy Traffic
    #      :referral_medium_percent => 10, #à cause de la policy Traffic
    #      :advertising_percent => 5, #à cause de la policy Traffic
    #      :advertisers => ["adsense"] #à cause de la policy Traffic
    #
    #
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :scraperbot,
    #  :data => {:policy_id => 2, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-ga", :statistics_type => :ga,
    #            :monday_start => next_monday(Date.today),
    #            :count_weeks => 4,
    #            :profil_id_ga => "123456",
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :keywords => "22 rue saint augustin 75002 paris", #à cause de la policy Rank
    #            :count_visits_per_day => 20 #à cause de la policy Rank
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : GA
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :enginebot,
    #  :data => {:policy_id => 2, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-ga",
    #            :monday_start => next_monday(Date.today), #à cause de la policy Rank (scraping  organic)
    #            :count_weeks => 4,
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :count_visits_per_day => 20 #à cause de la policy Rank
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :scraperbot,
     :data => {:policy_id => 3, :policy_type => "Traffic", :website_id => 1, :website_label => "epilation-laser-definitive-default", :statistics_type => :default,
               :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), #à cause de la policy Traffic (scraping website & organic)
               :count_weeks => 4,
               :url_root => "http://www.epilation-laser-definitive.info/",
               :count_page => 0, #à cause de la policy Traffic
               :schemes => "http", #à cause de la policy Traffic
               :types => "global", #à cause de la policy Traffic
               :max_duration_scraping => MAX_DURATION_SCRAPING # +7  #à cause de la policy Traffic (scraping website & organic)
     }
    },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    {:destination => :enginebot,
     :data => {:policy_id => 3, :policy_type => "Traffic", :website_id => 1, :website_label => "epilation-laser-definitive-default",
               :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), #à cause de la policy Traffic (scraping website & organic)
               :count_weeks => 4,
               :url_root => "http://www.epilation-laser-definitive.info/",
               :change_count_visits_percent => 10, #à cause de la policy Traffic
               :change_bounce_visits_percent => 1, #à cause de la policy Traffic
               :direct_medium_percent => 10, #à cause de la policy Traffic
               :organic_medium_percent => 80, #à cause de la policy Traffic
               :referral_medium_percent => 10, #à cause de la policy Traffic
               :advertising_percent => 5, #à cause de la policy Traffic
               :advertisers => ["adsense"] #à cause de la policy Traffic

     }
    },


    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : DEFAULT
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :scraperbot,
    #  :data => {:policy_id => 4, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-default", :statistics_type => :default,
    #            :monday_start => next_monday(Date.today),  #à cause de la policy Rank (scraping  organic)
    #            :count_weeks => 4,
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :keywords => "22 rue saint augustin 75002 paris", #à cause de la policy Rank
    #            :count_visits_per_day => 20 #à cause de la policy Rank
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : DEFAULT
    # # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :enginebot,
    #  :data => {:policy_id => 4, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-default",
    #            :monday_start => next_monday(Date.today), #à cause de la policy Rank (scraping  organic)
    #            :count_weeks => 4,
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :count_visits_per_day => 20 #à cause de la policy Rank
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : TRAFFIC   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :scraperbot,
    #  :data => {:policy_id => 5, :policy_type => "Traffic", :website_id => 1, :website_label => "epilation-laser-definitive-custom", :statistics_type => :custom,
    #            :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), #à cause de la policy Traffic (scraping website & organic)
    #            :count_weeks => 4,
    #            :url_root => "http://www.epilation-laser-definitive.info/",
    #            :count_page => 0, #à cause de la policy Traffic
    #            :schemes => "http", #à cause de la policy Traffic
    #            :types => "global", #à cause de la policy Traffic
    #            :hourly_daily_distribution => [[0, 9], [1, 4], [2, 2], [3, 1], [4, 0], [5, 2], [6, 5], [7, 8], [8, 15], [9, 25], [10, 20], [11, 19], [12, 30], [13, 35], [14, 20], [15, 15], [16, 10], [17, 18], [18, 28], [19, 40], [20, 23], [21, 27], [22, 40], [23, 27]], #saisie par l'utilisateur pour statistique = :custom
    #            :percent_new_visit => 100, #saisie par l'utilisateur pour statistique = :custom
    #            :visit_bounce_rate => Random.new.rand(80..90), #saisie par l'utilisateur pour statistique = :custom
    #            :avg_time_on_site => Random.new.rand(60..1000), #saisie par l'utilisateur pour statistique = :custom
    #            :page_views_per_visit => Random.new.rand(1..20), #saisie par l'utilisateur pour statistique = :custom
    #            :max_duration_scraping => MAX_DURATION_SCRAPING # +7  #à cause de la policy Traffic (scraping website & organic)
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : TRAFFIC   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :enginebot,
    #  :data => {:policy_id => 5, :policy_type => "Traffic", :website_id => 1, :website_label => "epilation-laser-definitive-custom",
    #            :monday_start => next_monday(Date.today + MAX_DURATION_SCRAPING), #à cause de la policy Traffic (scraping website & organic)
    #            :count_weeks => 4,
    #            :url_root => "http://www.epilation-laser-definitive.info/",
    #            :change_count_visits_percent => 10, #à cause de la policy Traffic
    #            :change_bounce_visits_percent => 1, #à cause de la policy Traffic
    #            :direct_medium_percent => 10, #à cause de la policy Traffic
    #            :organic_medium_percent => 80, #à cause de la policy Traffic
    #            :referral_medium_percent => 10, #à cause de la policy Traffic
    #            :advertising_percent => 5, #à cause de la policy Traffic
    #            :advertisers => ["adsense"] #à cause de la policy Traffic
    #
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : SCRAPERBOT | POLICY : RANK   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :scraperbot,
    #  :data => {:policy_id => 6, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-custom", :statistics_type => :custom,
    #            :monday_start => next_monday(Date.today), #à cause de la policy Rank (scraping  organic)
    #            :count_weeks => 4,
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :keywords => "22 rue saint augustin 75002 paris", #à cause de la policy Rank
    #            :count_visits_per_day => 20, #à cause de la policy Rank
    #            :hourly_daily_distribution => [[0, 9], [1, 4], [2, 2], [3, 1], [4, 0], [5, 2], [6, 5], [7, 8], [8, 15], [9, 25], [10, 20], [11, 19], [12, 30], [13, 35], [14, 20], [15, 15], [16, 10], [17, 18], [18, 28], [19, 40], [20, 23], [21, 27], [22, 40], [23, 27]], #saisie par l'utilisateur pour statistique = :custom
    #            :percent_new_visit => 100, #saisie par l'utilisateur pour statistique = :custom
    #            :visit_bounce_rate => Random.new.rand(80..90), #saisie par l'utilisateur pour statistique = :custom
    #            :avg_time_on_site => Random.new.rand(60..1000), #saisie par l'utilisateur pour statistique = :custom
    #            :page_views_per_visit => Random.new.rand(1..20) #saisie par l'utilisateur pour statistique = :custom
    #  }
    # },
    # -----------------------------------------------------------------------------------------------------------------
    # DESTINATION : ENGINEBOT  | POLICY : RANK   | STATISTIC : CUSTOM
    # -----------------------------------------------------------------------------------------------------------------
    # {:destination => :enginebot,
    #  :data => {:policy_id => 6, :policy_type => "Rank", :website_id => 1, :website_label => "epilation-laser-definitive-custom",
    #            :monday_start => next_monday(Date.today), #à cause de la policy Rank (scraping  organic)
    #            :count_weeks => 4,
    #            :url_root => "http://centre.epilation-laser-definitive.info/11685.htm",
    #            :count_visits_per_day => 20 #à cause de la policy Rank
    #
    #  }
    # }

]


while !datas.empty?

  scraperbot, enginebot = datas.shift(2)

  $environement = "development"

  Publication.publish({
                          :scraperbot => scraperbot[:data],
                          :enginebot => enginebot[:data].merge!(param_enginebot)
                      })
end

