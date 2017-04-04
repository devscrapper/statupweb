class ChangeDefaultMinMaxCountDurationPageAdvertiserAdvert < ActiveRecord::Migration
  def change
    change_column_default :adverts, :min_count_page_advertiser, 3
    change_column_default :adverts, :max_count_page_advertiser, 10
    change_column_default :adverts, :min_duration_page_advertiser, 10
    change_column_default :adverts, :max_duration_page_advertiser, 60
  end
end
