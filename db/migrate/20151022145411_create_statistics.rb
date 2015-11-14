class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :label, null: false
      t.integer :count_visits_per_day, null: false
      t.integer :hourly_daily_distribution0, null: false
      t.integer :hourly_daily_distribution1, null: false
      t.integer :hourly_daily_distribution2, null: false
      t.integer :hourly_daily_distribution3, null: false
      t.integer :hourly_daily_distribution4, null: false
      t.integer :hourly_daily_distribution5, null: false
      t.integer :hourly_daily_distribution6, null: false
      t.integer :hourly_daily_distribution7, null: false
      t.integer :hourly_daily_distribution8, null: false
      t.integer :hourly_daily_distribution9, null: false
      t.integer :hourly_daily_distribution10, null: false
      t.integer :hourly_daily_distribution11, null: false
      t.integer :hourly_daily_distribution12, null: false
      t.integer :hourly_daily_distribution13, null: false
      t.integer :hourly_daily_distribution14, null: false
      t.integer :hourly_daily_distribution15, null: false
      t.integer :hourly_daily_distribution16, null: false
      t.integer :hourly_daily_distribution17, null: false
      t.integer :hourly_daily_distribution18, null: false
      t.integer :hourly_daily_distribution19, null: false
      t.integer :hourly_daily_distribution20, null: false
      t.integer :hourly_daily_distribution21, null: false
      t.integer :hourly_daily_distribution22, null: false
      t.integer :hourly_daily_distribution23, null: false
      t.integer :percent_new_visit, null: false
      t.integer :visit_bounce_rate, null: false
      t.integer :avg_time_on_site, null: false
      t.integer :page_views_per_visit, null: false

      t.timestamps null: false
    end
  end
end
