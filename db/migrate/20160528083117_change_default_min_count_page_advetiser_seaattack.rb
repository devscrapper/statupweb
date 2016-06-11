class ChangeDefaultMinCountPageAdvetiserSeaattack < ActiveRecord::Migration
  def change
    change_column_default :sea_attacks, :min_count_page_advertiser, 5
    change_column_default :sea_attacks, :min_duration_page_advertiser, 10
    change_column_default :sea_attacks, :max_duration_page_advertiser, 60


  end
end
