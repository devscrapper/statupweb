class AddIpGeoProxyVisits < ActiveRecord::Migration
  def change
    add_column :visits, :ip_geo_proxy, :string, default: "no geo", null: false
  end
end
