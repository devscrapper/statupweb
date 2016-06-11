class AddSeaIdToSeaAttack < ActiveRecord::Migration



    def change
      add_belongs_to :sea_attacks, :sea, index: true, null: true  unless column_exists?(:sea_attacks, :sea)

    end



end
