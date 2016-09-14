class GeoIp

  @@db = nil

  def self.load_db
    @@db = MaxMindDB.new('config/GeoLite2-City.mmdb')
  end


  def self.ip_to_country(ip)
    begin
      country = @@db.lookup(ip).country.name
    rescue Exception => e
        "unknown ip"
    else
      country
    end
  end
end
