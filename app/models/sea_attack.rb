require 'json'

class SeaAttack < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy
  has_many :visits, as: :policy, dependent: :destroy
  belongs_to :sea


  validates :sea_id, presence: {message: "must be given"}
  validates :statistic_type, :presence => true, inclusion: {in: %w(default custom), message: "%{value} is not a type"}
  validates :start_date, :presence => true
  validates :count_weeks, :presence => true, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 52}
  validates :state, :presence => true, inclusion: {in: %w(created published over), message: "%{value} is not a valid state"}
  validates :min_count_page_organic, :presence => true, :numericality => {:only_integer => true,
                                                                          :greater_than_or_equal_to => 2,
                                                                          :less_than => :max_count_page_organic}
  validates :max_count_page_organic, :presence => true, :numericality => {:only_integer => true,
                                                                          :less_than_or_equal_to => 10,
                                                                          :greater_than => :min_count_page_organic}
  validates :min_duration_page_organic, :presence => true, :numericality => {:only_integer => true,
                                                                             :greater_than_or_equal_to => 10,
                                                                             :less_than => :max_duration_page_organic}
  validates :max_duration_page_organic, :presence => true, :numericality => {:only_integer => true,
                                                                             :less_than_or_equal_to => 40,
                                                                             :greater_than => :min_duration_page_organic}
  validates :min_duration, :presence => true, :numericality => {:only_integer => true,
                                                                :greater_than_or_equal_to => 5,
                                                                :less_than => :max_duration}
  validates :max_duration, :presence => true, :numericality => {:only_integer => true,
                                                                :less_than_or_equal_to => 30,
                                                                :greater_than => :min_duration}
  validates :min_duration_website, :presence => true, :numericality => {:only_integer => true,
                                                                        :greater_than_or_equal_to => 10}
  validates :min_pages_website, :presence => true, :numericality => {:only_integer => true,
                                                                     :greater_than_or_equal_to => 2}
  validates :execution_mode, :presence => true, inclusion: {in: %w(auto manual), message: "%{value} is not a valid mode"}
  validates :min_count_page_advertiser, :presence => true, :numericality => {:only_integer => true,
                                                                             :greater_than_or_equal_to => 5,
                                                                             :less_than => :max_count_page_advertiser}
  validates :max_count_page_advertiser, :presence => true, :numericality => {:only_integer => true,
                                                                             :less_than_or_equal_to => 10,
                                                                             :greater_than => :min_count_page_advertiser}
  validates :min_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true,
                                                                                :greater_than_or_equal_to => 10,
                                                                                :less_than => :max_duration_page_advertiser}
  validates :max_duration_page_advertiser, :presence => true, :numericality => {:only_integer => true,
                                                                                :less_than_or_equal_to => 60,
                                                                                :greater_than => :min_duration_page_advertiser}
  validates :percent_local_page_advertiser, :presence => true, :numericality => {:only_integer => true,
                                                                                 :less_than_or_equal_to => 100}

  validate :cannot_be_in_the_past,
           :only_one_policy_for_a_sea_by_period

  DELAY_WEEK = 7

  # cette données est calculée à la volée à partir du Calednar de engine_bot et n'est jamais stockée
  attr_accessor :planed_dates

  def total_click_adwords
    total = 0
    visits
        .select("actions", "count_browsed_page", "state")
        .where(state: ["overttl", "started", "success", "fail"]).each { |v|
      # 'F' est le code action qui symbolise le click sur Adword
      total += v.actions.index("F") + 1 <= v.count_browsed_page ? 1 : 0 unless v.actions.index("F").nil?
    } if %w(published over).include?(state)
    total
  end

  def total_advert_tracking_reason
    visits
        .where(reason: ["advert tracking"])
        .count
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
      errors.add(:start_date, "must be now tomorrow") if start_date <= Date.today

    end
  end

  def only_one_policy_for_a_sea_by_period

    if !start_date.nil? and !count_weeks.nil?
      end_date = start_date + count_weeks * DELAY_WEEK
      policies = SeaAttack.select("start_date, count_weeks").where("sea_id =? and id <>?", sea_id, id)
      policies.each { |policy|
        # on considère que les debuts de chaque periode sont tj avant les fins de chaque période
        if policy.start_date + policy.count_weeks * DELAY_WEEK <= start_date or
            policy.start_date >= end_date
        else
          errors.add(:sea, "only one Seaattack policy on sea on same periode")
          return
        end
      }
    end
  end

  def self.terminate
    SeaAttack.where("state =?", "published").each { |policy|
      if Date.today > policy.start_date + policy.count_weeks * DELAY_WEEK
        # positionne la policy comme terminée
        policy.state = "over"
        policy.save(validate: false)
      end
    }
  end

  def to_hash
    policy = {:policy_id => id,
              :policy_type => self.class.name,
              :website_id => sea.id, # on conserve website_id dans l hash car c'est l'interface officielle de
              # l'object Policy dans enginebot. Peut êrre qu'un jour on fera un truc qui se spécialisera en fonction du type de policy
              :website_label => sea.label,
              :statistics_type => statistic_type,
              :start_date => start_date,
              :count_weeks => count_weeks,
              :keywords => sea.keywords,
              #TODO demain peut être qu'un SEA referencera plusieurs advertiser
              :advertisers => [sea.advertiser], # Array obligatoire car le moteur enginebot attend un array d'avetiser pour traffic#
              :fqdn_advertisings => sea.fqdn_advertisings,
              :min_count_page_advertiser => min_count_page_advertiser,
              :max_count_page_advertiser => max_count_page_advertiser,
              :min_duration_page_advertiser => min_duration_page_advertiser,
              :max_duration_page_advertiser => max_duration_page_advertiser,
              :percent_local_page_advertiser => percent_local_page_advertiser,
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

  def published?
     state == "published"
  end

end
