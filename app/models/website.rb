require 'addressable/uri'
require 'rest-client'
class Website < ActiveRecord::Base
  include Addressable
  serialize :schemes, Array
  serialize :types, Array
  serialize :advertisers, Array
  has_many :traffics
  has_many :ranks
  validates :label, :presence => true
  validates :count_page, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validate :check_url
end

def check_url
  begin
    uri = URI.parse(url_root)
    raise if uri.scheme.nil? or
        uri.hostname.nil? or
        uri.path.empty?
  rescue
    errors.add(:url_root, " : <#{url_root}> is malformmed")
  else
    begin
      RestClient.head(url_root)
    rescue Exception => e
      errors.add(:url_root, "can join website")
    else

    end
  end
end

def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end