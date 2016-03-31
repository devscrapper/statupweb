class AddOsBrowserToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :browser_name, :string, default: "", null: false
    add_column :visits, :browser_version, :string, default: "", null: false
    add_column :visits, :operating_system_name, :string, default: "", null: false
    add_column :visits, :operating_system_version, :string, default: "", null: false
  end
end

