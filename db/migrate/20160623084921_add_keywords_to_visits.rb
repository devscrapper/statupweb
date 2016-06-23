class AddKeywordsToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :keywords, :string, default: "no keyword", null: false
  end
end
