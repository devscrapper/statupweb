class Traffic < ActiveRecord::Base
  has_one :custom_statistic, as: :statistic
  belongs_to :website


  def to_json(*a)
    {
        :scraperbot => publish_to_scraperbot,
        :enginebot => publish_to_enginebot
    }
  end

  private


  def publish_to_scraperbot
    policy = {:policy_id => id, :policy_type => self.class.name, :website_id => website_id, :website_label => website.label, :statistics_type => statistic_type,
              :monday_start => monday_start, #à cause de la policy Traffic (scraping website & organic)
              :count_weeks => count_weeks,
              :url_root => website.url_root,
              :count_page => website.count_page, #à cause de la policy Traffic
              :schemes => website.schemes, #à cause de la policy Traffic
              :types => website.types, #à cause de la policy Traffic
              :max_duration_scraping => max_duration_scraping # +7  #à cause de la policy Traffic (scraping website & organic)
    }
    case statistic_type
      when :default

      when :custom
        policy.merge!({:hourly_daily_distribution => [custom_statistic.statistic.hourly_daily_distribution0,
                                                      custom_statistic.statistic.hourly_daily_distribution1,
                                                      custom_statistic.statistic.hourly_daily_distribution2,
                                                      custom_statistic.statistic.hourly_daily_distribution3,
                                                      custom_statistic.statistic.hourly_daily_distribution4,
                                                      custom_statistic.statistic.hourly_daily_distribution5,
                                                      custom_statistic.statistic.hourly_daily_distribution6,
                                                      custom_statistic.statistic.hourly_daily_distribution7,
                                                      custom_statistic.statistic.hourly_daily_distribution8,
                                                      custom_statistic.statistic.hourly_daily_distribution9,
                                                      custom_statistic.statistic.hourly_daily_distribution10,
                                                      custom_statistic.statistic.hourly_daily_distribution11,
                                                      custom_statistic.statistic.hourly_daily_distribution12,
                                                      custom_statistic.statistic.hourly_daily_distribution13,
                                                      custom_statistic.statistic.hourly_daily_distribution14,
                                                      custom_statistic.statistic.hourly_daily_distribution15,
                                                      custom_statistic.statistic.hourly_daily_distribution16,
                                                      custom_statistic.statistic.hourly_daily_distribution17,
                                                      custom_statistic.statistic.hourly_daily_distribution18,
                                                      custom_statistic.statistic.hourly_daily_distribution19,
                                                      custom_statistic.statistic.hourly_daily_distribution20,
                                                      custom_statistic.statistic.hourly_daily_distribution21,
                                                      custom_statistic.statistic.hourly_daily_distribution22,
                                                      custom_statistic.statistic.hourly_daily_distribution23], #saisie par l'utilisateur pour statistique = :custom
                       :percent_new_visit => custom_statistic.statistic.percent_new_visit, #saisie par l'utilisateur pour statistique = :custom
                       :visit_bounce_rate => custom_statistic.statistic.visit_bounce_rate, #saisie par l'utilisateur pour statistique = :custom
                       :avg_time_on_site => custom_statistic.statistic.avg_time_on_site, #saisie par l'utilisateur pour statistique = :custom
                       :page_views_per_visit => custom_statistic.statistic.page_views_per_visit, #saisie par l'utilisateur pour statistique = :custom
                      })
      when :ga
        policy.merge!({:profil_id_ga => website.profil_id_ga}) # à cause de l'option de statistique = :ga

    end
    policy
  end

  def publish_to_enginebot
    {
        :policy_id => id, :policy_type => self.class.name, :website_id => website_id, :website_label => website.label,
        :monday_start => monday_start, #à cause de la policy Traffic (scraping website & organic)
        :count_weeks => count_weeks,
        :url_root => website.url_root,
        :change_count_visits_percent => change_count_visits_percent, #à cause de la policy Traffic
        :change_bounce_visits_percent => change_bounce_visits_percent, #à cause de la policy Traffic
        :direct_medium_percent => direct_medium_percent, #à cause de la policy Traffic
        :organic_medium_percent => organic_medium_percent, #à cause de la policy Traffic
        :referral_medium_percent => referral_medium_percent, #à cause de la policy Traffic
        :advertising_percent => advertising_percent, #à cause de la policy Traffic
        :advertisers => website.advertisers,
        :min_count_page_advertiser => min_count_page_advertiser,
        :max_count_page_advertiser => max_count_page_advertiser,
        :min_duration_page_advertiser => min_duration_page_advertiser,
        :max_duration_page_advertiser => max_duration_page_advertiser,
        :percent_local_page_advertiser => percent_local_page_advertiser,
        :duration_referral => duration_referral,
        :min_count_page_organic => min_count_page_organic,
        :max_count_page_organic => max_count_page_organic,
        :min_duration_page_organic => min_duration_page_organic,
        :max_duration_page_organic => max_duration_page_organic,
        :min_duration => min_duration,
        :max_duration => max_duration,
        :min_duration_website => min_duration_website,
        :min_pages_website => min_pages_website
    }

  end

end
