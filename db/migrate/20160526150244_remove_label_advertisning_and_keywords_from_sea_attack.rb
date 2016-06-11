class RemoveLabelAdvertisningAndKeywordsFromSeaAttack < ActiveRecord::Migration
  def change
    remove_column :sea_attacks, :keywords
    remove_column :sea_attacks, :label_advertising
  end
end
