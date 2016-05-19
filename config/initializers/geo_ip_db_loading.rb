class GeoIp

  @@db = nil

  def self.load_db
    @@db = MaxMindDB.new('config/GeoLite2-City.mmdb')
  end


  def self.ip_to_country(ip)
    @@db.lookup(ip).country.name
  end
end
