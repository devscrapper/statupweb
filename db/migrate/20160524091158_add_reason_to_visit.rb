class AddReasonToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :reason, :string, default: "no reason", null: false
  end
end
