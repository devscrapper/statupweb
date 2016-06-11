class ChangeDefaultValueCountWeeksSeaAttack < ActiveRecord::Migration
  def change
    change_column_default :sea_attacks, :count_weeks, 1
  end
end
