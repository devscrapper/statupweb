class CreateActivityServers < ActiveRecord::Migration
  def change
    create_table :activity_servers do |t|
      t.string :label, null: false
      t.string :hostname, null: false
      t.string :state, null: false
      t.datetime :time, null: false
      t.string :error_label, null: false, default: ""
      t.string :backtrace, null: true,  default: [""]
      t.datetime :error_time, null: true
      t.timestamps null: false
    end
  end
end
