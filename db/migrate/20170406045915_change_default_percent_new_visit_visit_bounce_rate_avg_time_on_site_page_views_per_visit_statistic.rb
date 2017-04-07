class ChangeDefaultPercentNewVisitVisitBounceRateAvgTimeOnSitePageViewsPerVisitStatistic < ActiveRecord::Migration
  def change
    change_column_default :statistics, :percent_new_visit, 100
    change_column_default :statistics, :visit_bounce_rate, 0
    change_column_default :statistics, :avg_time_on_site, 15 * 60  #15 mn
    change_column_default :statistics, :page_views_per_visit, 1
  end
end
