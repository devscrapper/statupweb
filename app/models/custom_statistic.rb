class CustomStatistic < ActiveRecord::Base
  belongs_to :policy, polymorphic: true
  belongs_to :statistic

  validates :policy_id, presence: {message: "must be given"}
  validates :statistic_id, presence: {message: "must be given"}
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank SeaAttack), message: "%{value} is not a valid policy type"}
end


