class ActivityServer < ActiveRecord::Base
  serialize :backtrace, Array
  validates :label, :presence => true
  validates :time, :presence => true
  validates :hostname, :presence => true

  validates :state, :presence => true, inclusion: {in: %w(online fail), message: "%{value} is not a valid state server"}
end
