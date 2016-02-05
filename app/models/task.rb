class Task < ActiveRecord::Base
  belongs_to :traffic

  scope :history, ->(policy_type) { where(:policy_type => policy_type) }

  validates :policy_id, :presence => true
  validates :policy_type, :presence => true, inclusion: {in: %w(traffic rank), message: "%{value} is not a valid policy type"}
  validates :label, :presence => true
  validates :state, :presence => true
  validates :time, :presence => true
end
