class Task < ActiveRecord::Base
  belongs_to :policy, polymorphic: true

  validates :policy_id, :presence => true
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank), message: "%{value} is not a valid policy type"}
  validates :label, :presence => true
  validates :state, :presence => true
  validates :time, :presence => true
end
