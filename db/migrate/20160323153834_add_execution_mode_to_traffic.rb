class AddExecutionModeToTraffic < ActiveRecord::Migration
  def change
    add_column :traffics, :execution_mode, :string, default: :auto, null: false
  end
end
