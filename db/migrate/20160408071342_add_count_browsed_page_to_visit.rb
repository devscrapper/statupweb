class AddCountBrowsedPageToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :count_browsed_page, :integer, default: 0, null: false
  end
end
