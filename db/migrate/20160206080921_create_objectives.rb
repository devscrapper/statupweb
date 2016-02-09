class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.references :policy, polymorphic: true, index: true
      t.integer :count_visits, null: false
      t.integer :visit_bounce_rate, null: false
      t.integer :avg_time_on_site, null: false
      t.integer :page_views_per_visit, null: false
      t.string :hourly_distribution, null: false
      t.date :day, null: false
      t.timestamps null: false
    end
  end
end
