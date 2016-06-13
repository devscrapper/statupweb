class ChangeColTypeOfKeywordsAndLabelAdvertisingsInSea < ActiveRecord::Migration
  def change
    change_column :seas, :keywords, :text, :null => false
    change_column :seas, :label_advertising, :text, :null => false
  end
end
