require 'addressable/uri'

class Website < ActiveRecord::Base
  serialize :schemes, Array
  serialize :types, Array
  serialize :advertisers, Array
  has_many :traffics
  has_many :ranks
  validates :label , :presence => true
  validates :count_page, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validate :check_url
end

def check_url
  begin
   Addressable::Uri.parse(url_root)
  rescue
    errors.add(:url_root, " : <#{url_root}> is malformmed")
  else
    end
end

def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end