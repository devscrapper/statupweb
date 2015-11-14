json.array!(@ranks) do |rank|
  json.extract! rank, :id, :statistic_type, :monday_start, :count_weeks, :keywords, :count_visits_per_day, :website, :statistic_id, :min_count_page_organic, :max_count_page_organic, :min_duration_page_organic, :max_duration_page_organic, :min_duration, :max_duration, :min_duration_website, :min_pages_website
  json.url rank_url(rank, format: :json)
end
