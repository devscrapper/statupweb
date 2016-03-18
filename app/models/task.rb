class Task < ActiveRecord::Base
  belongs_to :policy, polymorphic: true

  validates :policy_id, :presence => true
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank), message: "%{value} is not a valid policy type"}
  validates :label, :presence => true
  validates :state, :presence => true, inclusion: {in: %w(over start init fail restarting), message: "%{value} is not a valid state"}
  validates :time, :presence => true
  validates :building_date, :presence => true
  validates :task_id, :presence => true
  validates :finish_time, presence: true, if: "['over','fail'].include?(state)"
  validates :error_label, presence: true, if: "state == 'fail'"
end
