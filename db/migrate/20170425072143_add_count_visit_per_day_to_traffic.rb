class AddCountVisitPerDayToTraffic < ActiveRecord::Migration
  def change
    add_column :traffics, :count_visits_per_day, :integer,  null: false, default: 1
  end
end
