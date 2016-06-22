class RenameLabelAdvertisingsToFqdnAdvertisingsInSeas < ActiveRecord::Migration
  def change
    rename_column :seas, :label_advertisings, :fqdn_advertisings
  end
end
