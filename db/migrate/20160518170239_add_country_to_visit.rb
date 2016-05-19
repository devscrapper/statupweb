class AddCountryToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :country_geo_proxy, :string, default: "no country", null: false
  end
end
