class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.belongs_to :website, index: true, null: false
      t.string :statistic_type, null: false
      t.date :monday_start, null: false
      t.integer :count_weeks, null: false, default: 1
      t.integer :count_visits_per_day, null: false, default: 0
      t.integer :advertising_percent, null: false, default: 100
      t.integer :max_duration_scraping, null: false, default: 1
      t.integer :min_count_page_advertiser, null: false, default: 10
      t.integer :max_count_page_advertiser, null: false, default: 15
      t.integer :min_duration_page_advertiser, null: false, default: 60
      t.integer :max_duration_page_advertiser, null: false, default: 120
      t.integer :percent_local_page_advertiser, null: false, default: 80
      t.integer :min_duration, null: false, default: 5
      t.integer :max_duration, null: false, default: 10
      t.integer :min_duration_website, null: false, default: 10
      t.integer :min_pages_website, null: false, default: 2
      t.string :execution_mode, null: false, default: :auto
      t.string :state, null: false, default: :created # :created, :published, running

      t.timestamps null: false
    end
  end
end
