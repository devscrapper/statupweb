class Rank < ActiveRecord::Base
  has_one :custom_statistic, as: :statistic
  belongs_to :website
  belongs_to :website
end
