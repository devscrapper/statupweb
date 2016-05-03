class AddPlanTimeStopTimeChangeDurationsToActions < ActiveRecord::Migration
  def change

      add_column :visits, :end_time, :datetime, null: true
      add_column :visits, :plan_time, :datetime, null: true
      rename_column :visits, :durations, :actions
      change_column :visits, :actions, :string, null: false, default: [] #serialisation
      change_column :visits, :start_time, :datetime, null: true

  end
end
