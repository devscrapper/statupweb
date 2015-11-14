class Statistic < ActiveRecord::Base
  has_many   :traffics
  has_many :ranks

end
