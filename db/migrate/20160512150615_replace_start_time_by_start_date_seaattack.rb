class ReplaceStartTimeByStartDateSeaattack < ActiveRecord::Migration
  def change
    change_column :sea_attacks, :start_time, :date
    rename_column :sea_attacks, :start_time, :start_date
  end
end
