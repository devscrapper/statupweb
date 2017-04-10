class ChangeDefaultCountBrowsedPageVisits < ActiveRecord::Migration
  def change
    change_column_default :visits, :count_browsed_page, -1
  end
end
