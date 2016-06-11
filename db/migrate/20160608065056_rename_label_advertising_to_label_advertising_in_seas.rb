class RenameLabelAdvertisingToLabelAdvertisingInSeas < ActiveRecord::Migration
  def change
    rename_column :seas, :label_advertising, :label_advertisings
  end
end
