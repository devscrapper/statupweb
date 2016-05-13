class RemoveMaxDurationScrapingSeaattacks < ActiveRecord::Migration
  def change
    remove_column :sea_attacks, :max_duration_scraping
  end
end
