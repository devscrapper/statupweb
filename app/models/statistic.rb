class Statistic < ActiveRecord::Base
 has_many :custom_statistics

def to_hash
  {:hourly_daily_distribution => [hourly_daily_distribution0,
                                  hourly_daily_distribution1,
                                  hourly_daily_distribution2,
                                  hourly_daily_distribution3,
                                  hourly_daily_distribution4,
                                  hourly_daily_distribution5,
                                  hourly_daily_distribution6,
                                  hourly_daily_distribution7,
                                  hourly_daily_distribution8,
                                  hourly_daily_distribution9,
                                  hourly_daily_distribution10,
                                  hourly_daily_distribution11,
                                  hourly_daily_distribution12,
                                  hourly_daily_distribution13,
                                  hourly_daily_distribution14,
                                  hourly_daily_distribution15,
                                  hourly_daily_distribution16,
                                  hourly_daily_distribution17,
                                  hourly_daily_distribution18,
                                  hourly_daily_distribution19,
                                  hourly_daily_distribution20,
                                  hourly_daily_distribution21,
                                  hourly_daily_distribution22,
                                  hourly_daily_distribution23], #saisie par l'utilisateur pour statistique = :custom
   :percent_new_visit => percent_new_visit, #saisie par l'utilisateur pour statistique = :custom
   :visit_bounce_rate => visit_bounce_rate, #saisie par l'utilisateur pour statistique = :custom
   :avg_time_on_site => avg_time_on_site, #saisie par l'utilisateur pour statistique = :custom
   :page_views_per_visit => page_views_per_visit, #saisie par l'utilisateur pour statistique = :custom
   :count_visits_per_day => count_visits_per_day #saisie par l'utilisateur pour statistique = :custom
  }
end

end