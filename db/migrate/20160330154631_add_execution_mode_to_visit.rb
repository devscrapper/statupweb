class AddExecutionModeToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :execution_mode, :string, default: :auto, null: false
  end
end
