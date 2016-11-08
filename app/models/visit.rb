class Visit < ActiveRecord::Base
  serialize :actions, Array
  belongs_to :policy, polymorphic: true
  has_many :pages, dependent: :destroy
  has_many :captchas, dependent: :destroy
  has_one :log, dependent: :destroy
  validates :policy_type, :presence => true, inclusion: {in: %w(Traffic Rank SeaAttack Advert), message: "%{value} is not a valid policy type"}
  validates :policy_id, :presence => true
  validates :id_visit, :presence => true
  validates :plan_time, :presence => true
  validates :start_time, :presence => false
  validates :end_time, :presence => false
  validates :landing_url, :presence => true
  validates :actions, :presence => false
  validates :referrer, :presence => true
  validates :advert, :presence => true
  validates :state, :presence => true, inclusion: {in: %w(created scheduled published overttl outoftime neverstarted started  success fail advertnotfound), message: "%{value} is not a valid state"}
  validates :execution_mode, :presence => true, inclusion: {in: %w(auto manual), message: "%{value} is not a valid mode"}
  validates :browser_name, :presence => true
  validates :browser_version, :presence => true
  validates :operating_system_name, :presence => true
  validates :operating_system_version, :presence => true
  validates :count_browsed_page, :presence => true
  validates :ip_geo_proxy, :presence => true
  validates :reason, :presence => true , :if => "state == \"fail\""
  validates :keywords, :presence => true

  scope :plan_today, ->(time) { where("date(plan_time) = ?", time) }
end
