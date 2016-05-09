class Rank < ActiveRecord::Base
  has_one :custom_statistic, as: :policy, dependent: :destroy
  belongs_to :website
  has_many :tasks, as: :policy, dependent: :destroy
  has_many :objectives, as: :policy, dependent: :destroy
end
