class Sea < ActiveRecord::Base
  serialize :fqdn_advertisings, Array
  serialize :keywords, Array
  has_many :sea_attacks

  validates :label, :presence => true
  validates :keywords, :presence => true
  validates :advertiser, :presence => true, inclusion: {in: %w(adwords), message: "%{value} is not a valid advertiser"}
  validates :fqdn_advertisings, :presence => true
  #TODO validates_associated :sea_attacks,
  # met en forme pour affichage les fqdn_advertisings du Sea
  def fqdn_advertisings_dspl
    fqdn_advertisings.is_a?(Array)? fqdn_advertisings.join(", ") : fqdn_advertisings
  end
  def keywords_dspl
    keywords.is_a?(Array)? keywords.join(", ") : keywords
  end
  def published?
    !sea_attacks.where(:state => "published").empty?
  end
  def published
    # il est forcément unique car il y a un seule policy en même temp pour un SEA
    sea_attacks.where(:state => "published").first
  end
end
