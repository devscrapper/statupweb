class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

      t.string :label, null: false
      t.references :policy, polymorphic: true, index: true
      t.datetime :time, null: false
      t.string :state, null: false
      t.timestamps null: false
    end
  end
end
