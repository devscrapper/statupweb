require 'json'

class Advert < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy
  has_many :visits, as: :policy, dependent: :destroy
  belongs_to :website

  validates :website_id, presence: {message: "must be given"}
  validates :statistic_type, :presence => true
  validates :monday_start, :presence => true
  validates :state, :presence => true, inclusion: {in: %w(created published over), message: "%{value} is not a valid state"}
  validates :count_weeks, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 52}
  validates :max_duration_scraping, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}
  validates :min_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :max_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 15}
  validates :min_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 60}
  validates :max_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 120}
  validates :percent_local_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 100}
  validates :min_duration, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 5}
  validates :max_duration, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 30}
  validates :min_duration_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :min_pages_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 2}
  validates :execution_mode, :presence => true, inclusion: {in: %w(auto manual), message: "%{value} is not a valid mode"}

  validate :monday_start_cannot_be_in_the_past,
           :only_one_policy_for_a_website_by_period

  DELAY_WEEK = 7

  # cette données est calculée à la volée à partir du Calednar de engine_bot et n'est jamais stockée
  attr_accessor :planed_dates


  def destroy
    begin
      Publication::delete(id, self.class.name.downcase)

    rescue Exception => e
      raise "Advert n°#{id} was not unpublished : #{e.message}"

    else

    end if state.to_sym == :published

    super
  end




  def monday_start_cannot_be_in_the_past
    if !monday_start.nil?
      errors.add(:monday_start, "must be in the future and #{max_duration_scraping}") if !monday_start.nil? and monday_start.to_time.to_i - Time.now.to_i <= max_duration_scraping * 24 * 60 * 60 #en hour
    end
  end

  def only_one_policy_for_a_website_by_period

    if !monday_start.nil? and !count_weeks.nil?
      end_date = monday_start + count_weeks * DELAY_WEEK
      policies = Advert.select("monday_start, count_weeks").where("website_id =? and id <>?", website_id, id)
      policies.each { |policy|
        # on considère que les debuts de chaque periode sont tj avant les fins de chaque période
        logger.debug "#{policy.monday_start + policy.count_weeks * DELAY_WEEK } <= #{monday_start}#{policy.monday_start + policy.count_weeks * DELAY_WEEK <= monday_start}"
        logger.debug "#{policy.monday_start} >= #{end_date}#{policy.monday_start >= end_date}"
        if policy.monday_start + policy.count_weeks * DELAY_WEEK <= monday_start or
            policy.monday_start >= end_date
        else
          errors.add(:website, "only one policy on same periode")
          return
        end
      }
    end
  end

  def self.terminate
    Advert.where("state =?", "published").each { |policy|
      if Date.today > policy.monday_start + policy.count_weeks * DELAY_WEEK
        # positionne la policy comme terminée
        policy.state = "over"
        policy.save(validate: false)
      end
    }
  end

  def to_hash
    policy = {:policy_id => id,
              :policy_type => self.class.name,
              :website_id => website_id,
              :website_label => website.label,
              :statistics_type => "default",
              :monday_start => monday_start, #à cause de la policy Advert (scraping website & organic)
              :count_weeks => count_weeks,
              :url_root => website.url_root,
              :count_visits_per_day => count_visits_per_day,
              :count_page => website.count_page, #à cause de la policy Advert
              :schemes => website.schemes, #à cause de la policy Advert
              :types => website.types, #à cause de la policy Advert
              :max_duration_scraping => max_duration_scraping, # +7  #à cause de la policy Advert (scraping website & organic)
              :advertising_percent => advertising_percent, #à cause de la policy Advert
              :advertisers => website.advertisers,
              :min_count_page_advertiser => min_count_page_advertiser,
              :max_count_page_advertiser => max_count_page_advertiser,
              :min_duration_page_advertiser => min_duration_page_advertiser,
              :max_duration_page_advertiser => max_duration_page_advertiser,
              :percent_local_page_advertiser => percent_local_page_advertiser,
              :min_duration => min_duration,
              :max_duration => max_duration,
              :min_duration_website => min_duration_website,
              :min_pages_website => min_pages_website,
              :execution_mode => execution_mode
    }

    logger.debug policy
    policy
  end

  private


end
