require 'json'

class Traffic < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy
  has_many :visits, as: :policy, dependent: :destroy
  belongs_to :website

  validates :website_id, presence: {message: "must be given"}
  validates :statistic_type, :presence => true
  validates :monday_start, :presence => true
  validates :count_weeks, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 52}
  validates :change_count_visits_percent, :numericality => {:only_integer => true, :other_than => 0, :greater_than_or_equal_to => -100, :less_than_or_equal_to => 100}
  validates :change_bounce_visits_percent, :numericality => {:only_integer => true, :greater_than_or_equal_to => -100, :less_than_or_equal_to => 100}
  validates :direct_medium_percent, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :organic_medium_percent, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :referral_medium_percent, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :advertising_percent, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10}
  validates :max_duration_scraping, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}
  validates :min_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :max_count_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 15}
  validates :min_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 60}
  validates :max_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 120}
  validates :percent_local_page_advertiser, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 100}
  validates :duration_referral, :presence => true, :numericality => {:only_integer => true}
  validates :min_count_page_organic, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 4}
  validates :max_count_page_organic, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 20}
  validates :min_duration_page_organic, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :max_duration_page_organic, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 40}
  validates :min_duration, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 5}
  validates :max_duration, :presence => true, :numericality => {:only_integer => true, :less_than_or_equal_to => 30}
  validates :min_duration_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 10}
  validates :min_pages_website, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 2}
  validates :execution_mode, :presence => true, inclusion: {in: %w(auto manual), message: "%{value} is not a valid mode"}

  validate :monday_start_cannot_be_in_the_past_and_must_be_on_monday,
           :sum_of_medium_percent_must_equal_to_100,
           :only_one_policy_for_a_website_by_period,
           :organic_medium_is_non_zero_if_website_has_keywords,
           :referral_medium_is_non_zero_if_website_has_referrals

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
      raise "Traffic n°#{id} was not unpublished : #{e.message}"

    else

    end if state.to_sym == :published

    super
  end

  def organic_medium_is_non_zero_if_website_has_keywords

    if !website.nil? and website.count_organic <= 0 and !organic_medium_percent.nil? and organic_medium_percent > 0
      errors.add(:organic_medium_percent, "must be equal to zero because website <#{website.label}> has none keyword")
    end

  end

  def referral_medium_is_non_zero_if_website_has_referrals

    if !website.nil? and website.count_referral <= 0 and !referral_medium_percent.nil? and referral_medium_percent > 0
      errors.add(:referral_medium_percent, "must be equal to zero because website <#{website.label}> has none referral")
    end

  end


  def sum_of_medium_percent_must_equal_to_100
    if !direct_medium_percent.nil? and
        !organic_medium_percent.nil? and
        !referral_medium_percent.nil?
      errors.add(:base, "Distribution of medium percent must be equal to 100") if direct_medium_percent + organic_medium_percent + referral_medium_percent != 100
    end
  end


  def monday_start_cannot_be_in_the_past_and_must_be_on_monday
    if !monday_start.nil?
      errors.add(:monday_start, "must be in the future and #{max_duration_scraping} days before next monday") if !monday_start.nil? and monday_start - Date.today <= max_duration_scraping
      errors.add(:monday_start, "must be on monday") if !monday_start.monday?
    end
  end

  def only_one_policy_for_a_website_by_period

    if !monday_start.nil? and !count_weeks.nil?
      end_date = monday_start + count_weeks * DELAY_WEEK
      policies = Traffic.select("monday_start, count_weeks").where("website_id =? and id <>?", website_id, id)
      policies.each { |policy|
        # on considère que les debuts de chaque periode sont tj avant les fins de chaque période
        p "#{policy.monday_start + policy.count_weeks * DELAY_WEEK } <= #{monday_start}#{policy.monday_start + policy.count_weeks * DELAY_WEEK <= monday_start}"
        p "#{policy.monday_start} >= #{end_date}#{policy.monday_start >= end_date}"
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
    Traffic.where("state =?", "published").each { |policy|
      if Date.today > policy.monday_start + policy.count_weeks * DELAY_WEEK
        # positionne la policy comme terminée
        policy.state = "over"
        policy.save(validate: false)
      end
    }
  end

  def to_hash
    policy = {:policy_id => id, :policy_type => self.class.name, :website_id => website_id, :website_label => website.label, :statistics_type => statistic_type,
              :monday_start => monday_start, #à cause de la policy Traffic (scraping website & organic)
              :count_weeks => count_weeks,
              :url_root => website.url_root,
              :count_page => website.count_page, #à cause de la policy Traffic
              :schemes => website.schemes, #à cause de la policy Traffic
              :types => website.types, #à cause de la policy Traffic
              :max_duration_scraping => max_duration_scraping, # +7  #à cause de la policy Traffic (scraping website & organic)
              :change_count_visits_percent => change_count_visits_percent, #à cause de la policy Traffic
              :change_bounce_visits_percent => change_bounce_visits_percent, #à cause de la policy Traffic
              :direct_medium_percent => direct_medium_percent, #à cause de la policy Traffic
              :organic_medium_percent => organic_medium_percent, #à cause de la policy Traffic
              :referral_medium_percent => referral_medium_percent, #à cause de la policy Traffic
              :advertising_percent => advertising_percent, #à cause de la policy Traffic
              :advertisers => website.advertisers,
              :min_count_page_advertiser => min_count_page_advertiser,
              :max_count_page_advertiser => max_count_page_advertiser,
              :min_duration_page_advertiser => min_duration_page_advertiser,
              :max_duration_page_advertiser => max_duration_page_advertiser,
              :percent_local_page_advertiser => percent_local_page_advertiser,
              :duration_referral => duration_referral,
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
      when "ga"
        policy.merge!({:profil_id_ga => website.profil_id_ga}) # à cause de l'option de statistique = :ga

    end
    policy
  end

  private


end
