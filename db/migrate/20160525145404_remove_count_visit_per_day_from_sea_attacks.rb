class RemoveCountVisitPerDayFromSeaAttacks < ActiveRecord::Migration
  def change
    remove_column :sea_attacks, :count_visits_per_day
  end
end
