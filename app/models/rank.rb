class Rank < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  belongs_to :website
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy

  def self.terminate
    Rank.where("state =?", "published").each { |policy|
      if Date.today > policy.monday_start + policy.count_weeks * DELAY_WEEK
        # positionne la policy comme terminée
        policy.state = "over"
        policy.save(validate: false)
      end
    }
  end
end
