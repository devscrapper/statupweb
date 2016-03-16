class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

      t.string :label, null: false
      t.references :policy, polymorphic: true, index: true
      t.datetime :time, null: false
      t.string :state, null: false
      t.date :building_date, :date, null: false
      t.datetime :finish_time, :date,  null: true
      t.string :task_id, :string, null: false, index: true
      t.string :error_label, :string, null: true
      t.timestamps null: false
    end
  end
end
