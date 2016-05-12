class ReplaceMondayStartByStartTimeSeaattack < ActiveRecord::Migration
  def change
    change_column :sea_attacks, :monday_start, :datetime
    rename_column :sea_attacks, :monday_start, :start_time
    change_column_default :sea_attacks, :max_duration_scraping, from: 1, to: 0
  end
end
