class Objective < ActiveRecord::Base
  belongs_to :policy, polymorphic: true

  validates :policy_id, :presence => true
  validates :count_visits, :presence => true, :numericality => true
  validates :visit_bounce_rate, :presence => true, :numericality => true
  validates :avg_time_on_site, :presence => true, :numericality => true
  validates :page_views_per_visit, :presence => true , :numericality => true
  validates :hourly_distribution, :presence => true
  validates :day, :presence => true
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank SeaAttack), message: "%{value} is not a valid policy type"}

end
