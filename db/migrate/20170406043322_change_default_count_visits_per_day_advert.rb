class ChangeDefaultCountVisitsPerDayAdvert < ActiveRecord::Migration
  def change
    change_column_default :adverts, :count_visits_per_day, 1
  end
end
