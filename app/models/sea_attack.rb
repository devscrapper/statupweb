require 'json'

class SeaAttack < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy
  has_many :visits, as: :policy, dependent: :destroy
  belongs_to :website

  validates :website_id, presence: {message: "must be given"}
  validates :statistic_type, :presence => true
  validates :start_date, :presence => true
  validates :keywords, :presence => true
  validates :label_advertising, :presence => true
  validates :count_weeks, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 52}
  validates :count_visits_per_day, :numericality => {:only_integer => true, :other_than => 0, :greater_than_or_equal_to => -100, :less_than_or_equal_to => 100}
  validates :max_duration_scraping, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0} #TODO mettre valeur par defaut non customisable ?
  validates :min_count_page_organic, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 4}
  validates :max_count_page_organic, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 20}
  validates :min_duration_page_organic, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :max_duration_page_organic, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 40}
  validates :min_duration, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 5}
  validates :max_duration, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 30}
  validates :min_duration_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :min_pages_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 2}
  validates :execution_mode, :presence => true, inclusion: {in: %w(auto manual), message: "%{value} is not a valid mode"}
  validates :min_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :max_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 15}
  validates :min_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 60}
  validates :max_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 120}
  validates :percent_local_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 100}
  validates :percent_local_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 100}
  validate :cannot_be_in_the_past,
           :only_one_policy_for_a_website_by_period

  DELAY_WEEK = 7

  # cette données est calculée à la volée à partir du Calednar de engine_bot et n'est jamais stockée
  attr_accessor :planed_dates

  def self.next_monday(date)
    today = Date.parse(date) if date.is_a?(String)
    today = date if date.is_a?(Date)

    return today.next_day(1) if today.sunday?
    return today.next_day(2) if today.saturday?
    return today.next_day(3) if today.friday?
    return today.next_day(4) if today.thursday?
    return today.next_day(5) if today.wednesday?
    return today.next_day(6) if today.tuesday?
    return today.next_day(7) if today.monday?
  end

  def destroy
    CustomStatistic.where(policy_id: id, policy_type: "traffic").delete_all if statistic_type == "custom"

    begin
      Publication::delete(id, self.class.name.downcase)

    rescue Exception => e
      raise "Sea Attack n°#{id} was not unpublished : #{e.message}"

    else

    end if state.to_sym == :published

    super
  end


  def cannot_be_in_the_past
    if !start_date.nil?
      errors.add(:start_date, "must be after tomorrow or later") if start_date < Date.today.next_day(2)

    end
  end

  def only_one_policy_for_a_website_by_period

    if !start_date.nil? and !count_weeks.nil?
      end_date = start_date + count_weeks * DELAY_WEEK
      policies = SeaAttack.select("start_date, count_weeks").where("website_id =? and id <>?", website_id, id)
      policies.each { |policy|
        # on considère que les debuts de chaque periode sont tj avant les fins de chaque période
        p "#{policy.start_date + policy.count_weeks * DELAY_WEEK } <= #{start_date}#{policy.start_date + policy.count_weeks * DELAY_WEEK <= start_date}"
        p "#{policy.start_date} >= #{end_date}#{policy.start_date >= end_date}"
        if policy.start_date + policy.count_weeks * DELAY_WEEK <= start_date or
            policy.start_date >= end_date
        else
          errors.add(:website, "only one Seaattack policy on website on same periode")
          return
        end
      }
    end
  end

  def to_hash
    policy = {:policy_id => id,
              :policy_type => self.class.name, :website_id => website_id, :website_label => website.label, :statistics_type => statistic_type,
              :start_date => start_date,
              :count_weeks => count_weeks,
              :keywords => keywords,
              :url_root => website.url_root,
              :max_duration_scraping => max_duration_scraping, # +7  #à cause de la policy Traffic (scraping website & organic)
              :count_visits_per_day => count_visits_per_day, #à cause de la policy Traffic
              :advertising_percent => 100, #à cause de la policy Traffic
              :advertisers => "adwords",
              :label_advertising => label_advertising, #TODO encode e utf8
              :min_count_page_advertiser => min_count_page_advertiser,
              :max_count_page_advertiser => max_count_page_advertiser,
              :min_duration_page_advertiser => min_duration_page_advertiser,
              :max_duration_page_advertiser => max_duration_page_advertiser,
              :percent_local_page_advertiser => 100,
              :min_count_page_organic => min_count_page_organic,
              :max_count_page_organic => max_count_page_organic,
              :min_duration_page_organic => min_duration_page_organic,
              :max_duration_page_organic => max_duration_page_organic,
              :min_duration => min_duration,
              :max_duration => max_duration,
              :min_duration_website => min_duration_website,
              :min_pages_website => min_pages_website,
              :execution_mode => execution_mode
    }
    case statistic_type
      when "default"

      when "custom"
        policy.merge!(custom_statistic.statistic.to_hash)

    end
    policy
  end

end
