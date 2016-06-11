class ChangeDefaultValueMaxCoutPageAdvertiserAndMaxDurationPageAdvertiserseaAttack < ActiveRecord::Migration
  def change
    change_column_default :sea_attacks, :max_count_page_advertiser, 10
    change_column_default :sea_attacks, :max_duration_page_advertiser, 60
  end
end
