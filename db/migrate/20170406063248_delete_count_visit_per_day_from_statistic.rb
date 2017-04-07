class DeleteCountVisitPerDayFromStatistic < ActiveRecord::Migration
  def change
    remove_column :statistics, :count_visits_per_day
  end
end
