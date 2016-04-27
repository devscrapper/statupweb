json.array!(@traffics) do |traffic|
  json.extract! traffic, :id, :statistic_type, :website_id, :statistic_id, :#, :peut, :�tre, :null, :si, :statistic_type, :!=, :, :monday_start, :count_weeks, :change_count_visits_percent, :change_bounce_visits_percent, :direct_medium_percent, :organic_medium_percent, :referral_medium_percent, :advertising_percent, :advertisers, :max_duration_scraping, :min_count_page_advertiser, :max_count_page_advertiser, :min_duration_page_advertiser, :max_duration_page_advertiser, :percent_local_page_advertiser, :duration_referral, :min_count_page_organic, :max_count_page_organic, :min_duration_page_organic, :max_duration_page_organic, :min_duration, :max_duration, :min_duration_website, :min_pages_website
  json.url traffic_url(traffic, format: :json)
end
