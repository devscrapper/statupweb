class RemoveWebsiteFromSeaAttack < ActiveRecord::Migration
  def change
    remove_belongs_to(:sea_attacks, :website)
    change_column_null(:sea_attacks, :sea_id, true)
  end
end
