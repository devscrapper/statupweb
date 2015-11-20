class CreateTraffics < ActiveRecord::Migration
  def change
    create_table :traffics do |t|
      t.belongs_to :website, index: true, null: false
      t.string :statistic_type, null: false
      t.date :monday_start, null: false
      t.integer :count_weeks, null: false , default: 0
      t.integer :change_count_visits_percent, null: false, default: 0
      t.integer :change_bounce_visits_percent, null: false, default: 0
      t.integer :direct_medium_percent, null: false, default: 0
      t.integer :organic_medium_percent, null: false, default: 0
      t.integer :referral_medium_percent, null: false, default: 0
      t.integer :advertising_percent, null: false, default: 0
      t.integer :max_duration_scraping, null: false, default: 7
      t.integer :min_count_page_advertiser, null: false, default: 10
      t.integer :max_count_page_advertiser, null: false, default: 15
      t.integer :min_duration_page_advertiser, null: false, default: 60
      t.integer :max_duration_page_advertiser, null: false, default: 120
      t.integer :percent_local_page_advertiser, null: false, default: 80
      t.integer :duration_referral, null: false, default: 20
      t.integer :min_count_page_organic, null: false, default: 4
      t.integer :max_count_page_organic, null: false, default: 6
      t.integer :min_duration_page_organic, null: false, default: 10
      t.integer :max_duration_page_organic, null: false, default: 30
      t.integer :min_duration, null: false, default: 5
      t.integer :max_duration, null: false, default: 10
      t.integer :min_duration_website, null: false, default: 10
      t.integer :min_pages_website, null: false, default: 2
      t.string :state, null: false, default: :created        # :created, :published, running

      t.timestamps null: false
    end
  end
end
