class ChangeDefaultHourlyDailyDistributionPageViewPerVisitAvgTimeOnSiteStatistic < ActiveRecord::Migration
  def change
    change_column_default :statistics, :avg_time_on_site, 3 * 60 #15 mn
    change_column_default :statistics, :page_views_per_visit, 4
    change_column_default :statistics, :hourly_daily_distribution0, 4
    change_column_default :statistics, :hourly_daily_distribution1, 0
    change_column_default :statistics, :hourly_daily_distribution2, 0
    change_column_default :statistics, :hourly_daily_distribution3, 0
    change_column_default :statistics, :hourly_daily_distribution4, 0
    change_column_default :statistics, :hourly_daily_distribution5, 0
    change_column_default :statistics, :hourly_daily_distribution6, 0
    change_column_default :statistics, :hourly_daily_distribution7, 0
    change_column_default :statistics, :hourly_daily_distribution8, 0
    change_column_default :statistics, :hourly_daily_distribution9, 0
    change_column_default :statistics, :hourly_daily_distribution10, 8
    change_column_default :statistics, :hourly_daily_distribution11, 0
    change_column_default :statistics, :hourly_daily_distribution12, 0
    change_column_default :statistics, :hourly_daily_distribution13, 0
    change_column_default :statistics, :hourly_daily_distribution14, 0
    change_column_default :statistics, :hourly_daily_distribution15, 0
    change_column_default :statistics, :hourly_daily_distribution16, 0
    change_column_default :statistics, :hourly_daily_distribution17, 0
    change_column_default :statistics, :hourly_daily_distribution18, 0
    change_column_default :statistics, :hourly_daily_distribution19, 0
    change_column_default :statistics, :hourly_daily_distribution20, 0
    change_column_default :statistics, :hourly_daily_distribution21, 0
    change_column_default :statistics, :hourly_daily_distribution22, 0
    change_column_default :statistics, :hourly_daily_distribution23, 0

  end
end
