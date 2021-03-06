json.array!(@statistics) do |statistic|
  json.extract! statistic, :id, :label, :count_visits_per_day, :hourly_daily_distribution, :percent_new_visit, :visit_bounce_rate, :avg_time_on_site, :page_views_per_visit
  json.url statistic_url(statistic, format: :json)
end
