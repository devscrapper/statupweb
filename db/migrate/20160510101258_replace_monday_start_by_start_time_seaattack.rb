class ReplaceMondayStartByStartTimeSeaattack < ActiveRecord::Migration
  def change
    change_column :sea_attacks, :monday_start, :datetime
    rename_column :sea_attacks, :monday_start, :start_time
  end
end
