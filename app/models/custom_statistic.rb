class CustomStatistic < ActiveRecord::Base
  belongs_to :policy, polymorphic: true
  belongs_to :statistic
end


