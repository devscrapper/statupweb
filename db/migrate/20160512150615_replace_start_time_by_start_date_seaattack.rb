class ReplaceStartTimeByStartDateSeaattack < ActiveRecord::Migration
  def change
    rename_column :sea_attacks, :start_time, :start_date
  end
end
