class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :visit_id, null: false
      t.string :log_file_id, null: true
      t.timestamps null: false
    end
    add_index :logs, :visit_id
  end
end
