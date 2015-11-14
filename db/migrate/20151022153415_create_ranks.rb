class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :statistic_type, null: false
      t.date :monday_start, null: false
      t.integer :count_weeks, null: false
      t.string :keywords, null: false
      t.integer :count_visits_per_day, null: false
      t.belongs_to :website, index: true, null: false
      t.integer :min_count_page_organic, null: false, default: 4
      t.integer :max_count_page_organic, null: false, default: 6
      t.integer :min_duration_page_organic, null: false, default: 10
      t.integer :max_duration_page_organic, null: false, default: 30
      t.integer :min_duration, null: false, default: 5
      t.integer :max_duration, null: false, default: 10
      t.integer :min_duration_website, null: false, default: 10
      t.integer :min_pages_website, null: false, default: 2


      t.timestamps null: false
    end
  end
end
