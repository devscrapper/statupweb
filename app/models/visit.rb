class Visit < ActiveRecord::Base

  belongs_to :policy, polymorphic: true
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank), message: "%{value} is not a valid policy type"}
  validates :policy_id, :presence => true
  validates :id_visit, :presence => true
  validates :start_time, :presence => true
  validates :landing_url, :presence => true
  validates :durations, :presence => true
  validates :referrer, :presence => true
  validates :advert, :presence => true
  validates :state, :presence => true, inclusion: {in: %w(created scheduled started success fail), message: "%{value} is not a valid state"}

end

