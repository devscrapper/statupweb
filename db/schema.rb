# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161124121700) do

  create_table "activity_servers", force: :cascade do |t|
    t.string   "label",                               null: false
    t.string   "hostname",                            null: false
    t.string   "state",                               null: false
    t.datetime "time",                                null: false
    t.string   "error_label", default: "",            null: false
    t.string   "backtrace",   default: "---\n- ''\n"
    t.datetime "error_time"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "adverts", force: :cascade do |t|
    t.integer  "website_id",                                        null: false
    t.string   "statistic_type",                default: "default", null: false
    t.date     "monday_start",                                      null: false
    t.integer  "count_weeks",                   default: 1,         null: false
    t.integer  "count_visits_per_day",          default: 0,         null: false
    t.integer  "advertising_percent",           default: 100,       null: false
    t.integer  "max_duration_scraping",         default: 1,         null: false
    t.integer  "min_count_page_advertiser",     default: 10,        null: false
    t.integer  "max_count_page_advertiser",     default: 15,        null: false
    t.integer  "min_duration_page_advertiser",  default: 60,        null: false
    t.integer  "max_duration_page_advertiser",  default: 120,       null: false
    t.integer  "percent_local_page_advertiser", default: 80,        null: false
    t.integer  "min_duration",                  default: 5,         null: false
    t.integer  "max_duration",                  default: 10,        null: false
    t.integer  "min_duration_website",          default: 10,        null: false
    t.integer  "min_pages_website",             default: 2,         null: false
    t.string   "execution_mode",                default: "auto",    null: false
    t.string   "state",                         default: "created", null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "adverts", ["website_id"], name: "index_adverts_on_website_id"

  create_table "captchas", force: :cascade do |t|
    t.string   "visit_id",                          null: false
    t.string   "image_file_id"
    t.integer  "index",                             null: false
    t.string   "text",          default: "unknown", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "captchas", ["visit_id"], name: "index_captchas_on_visit_id"

  create_table "custom_statistics", force: :cascade do |t|
    t.integer  "policy_id"
    t.string   "policy_type"
    t.integer  "statistic_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "custom_statistics", ["policy_type", "policy_id"], name: "index_custom_statistics_on_policy_type_and_policy_id"
  add_index "custom_statistics", ["statistic_id"], name: "index_custom_statistics_on_statistic_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "logs", force: :cascade do |t|
    t.string   "visit_id",    null: false
    t.string   "log_file_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "logs", ["visit_id"], name: "index_logs_on_visit_id"

  create_table "objectives", force: :cascade do |t|
    t.integer  "policy_id"
    t.string   "policy_type"
    t.integer  "count_visits",         null: false
    t.integer  "visit_bounce_rate",    null: false
    t.integer  "avg_time_on_site",     null: false
    t.integer  "page_views_per_visit", null: false
    t.string   "hourly_distribution",  null: false
    t.date     "day",                  null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "objectives", ["policy_type", "policy_id"], name: "index_objectives_on_policy_type_and_policy_id"

  create_table "pages", force: :cascade do |t|
    t.string   "visit_id",       null: false
    t.string   "image_file_id"
    t.integer  "index",          null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "source_file_id"
  end

  add_index "pages", ["visit_id"], name: "index_pages_on_visit_id"

  create_table "ranks", force: :cascade do |t|
    t.string   "statistic_type",                         null: false
    t.date     "monday_start",                           null: false
    t.integer  "count_weeks",                            null: false
    t.string   "keywords",                               null: false
    t.integer  "count_visits_per_day",                   null: false
    t.integer  "website_id",                             null: false
    t.integer  "min_count_page_organic",    default: 4,  null: false
    t.integer  "max_count_page_organic",    default: 6,  null: false
    t.integer  "min_duration_page_organic", default: 10, null: false
    t.integer  "max_duration_page_organic", default: 30, null: false
    t.integer  "min_duration",              default: 5,  null: false
    t.integer  "max_duration",              default: 10, null: false
    t.integer  "min_duration_website",      default: 10, null: false
    t.integer  "min_pages_website",         default: 2,  null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "ranks", ["website_id"], name: "index_ranks_on_website_id"

  create_table "sea_attacks", force: :cascade do |t|
    t.string   "statistic_type",                                    null: false
    t.date     "start_date",                                        null: false
    t.integer  "count_weeks",                   default: 1,         null: false
    t.integer  "min_count_page_advertiser",     default: 5,         null: false
    t.integer  "max_count_page_advertiser",     default: 10,        null: false
    t.integer  "min_duration_page_advertiser",  default: 10,        null: false
    t.integer  "max_duration_page_advertiser",  default: 60,        null: false
    t.integer  "percent_local_page_advertiser", default: 80,        null: false
    t.integer  "min_count_page_organic",        default: 4,         null: false
    t.integer  "max_count_page_organic",        default: 6,         null: false
    t.integer  "min_duration_page_organic",     default: 10,        null: false
    t.integer  "max_duration_page_organic",     default: 30,        null: false
    t.integer  "min_duration",                  default: 5,         null: false
    t.integer  "max_duration",                  default: 10,        null: false
    t.integer  "min_duration_website",          default: 10,        null: false
    t.integer  "min_pages_website",             default: 2,         null: false
    t.string   "execution_mode",                default: "auto",    null: false
    t.string   "state",                         default: "created", null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "sea_id"
  end

  add_index "sea_attacks", ["sea_id"], name: "index_sea_attacks_on_sea_id"

  create_table "seas", force: :cascade do |t|
    t.string   "label",             null: false
    t.string   "advertiser",        null: false
    t.text     "keywords",          null: false
    t.text     "fqdn_advertisings", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.string   "label",                       null: false
    t.integer  "count_visits_per_day",        null: false
    t.integer  "hourly_daily_distribution0",  null: false
    t.integer  "hourly_daily_distribution1",  null: false
    t.integer  "hourly_daily_distribution2",  null: false
    t.integer  "hourly_daily_distribution3",  null: false
    t.integer  "hourly_daily_distribution4",  null: false
    t.integer  "hourly_daily_distribution5",  null: false
    t.integer  "hourly_daily_distribution6",  null: false
    t.integer  "hourly_daily_distribution7",  null: false
    t.integer  "hourly_daily_distribution8",  null: false
    t.integer  "hourly_daily_distribution9",  null: false
    t.integer  "hourly_daily_distribution10", null: false
    t.integer  "hourly_daily_distribution11", null: false
    t.integer  "hourly_daily_distribution12", null: false
    t.integer  "hourly_daily_distribution13", null: false
    t.integer  "hourly_daily_distribution14", null: false
    t.integer  "hourly_daily_distribution15", null: false
    t.integer  "hourly_daily_distribution16", null: false
    t.integer  "hourly_daily_distribution17", null: false
    t.integer  "hourly_daily_distribution18", null: false
    t.integer  "hourly_daily_distribution19", null: false
    t.integer  "hourly_daily_distribution20", null: false
    t.integer  "hourly_daily_distribution21", null: false
    t.integer  "hourly_daily_distribution22", null: false
    t.integer  "hourly_daily_distribution23", null: false
    t.integer  "percent_new_visit",           null: false
    t.integer  "visit_bounce_rate",           null: false
    t.integer  "avg_time_on_site",            null: false
    t.integer  "page_views_per_visit",        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "label",         null: false
    t.integer  "policy_id"
    t.string   "policy_type"
    t.datetime "time",          null: false
    t.string   "state",         null: false
    t.date     "building_date", null: false
    t.datetime "date"
    t.datetime "finish_time"
    t.string   "task_id",       null: false
    t.string   "string"
    t.string   "error_label"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tasks", ["policy_type", "policy_id"], name: "index_tasks_on_policy_type_and_policy_id"
  add_index "tasks", ["string"], name: "index_tasks_on_string"
  add_index "tasks", ["task_id"], name: "index_tasks_on_task_id"

  create_table "traffics", force: :cascade do |t|
    t.integer  "website_id",                                        null: false
    t.string   "statistic_type",                                    null: false
    t.date     "monday_start",                                      null: false
    t.integer  "count_weeks",                   default: 0,         null: false
    t.integer  "change_count_visits_percent",   default: 0,         null: false
    t.integer  "change_bounce_visits_percent",  default: 0,         null: false
    t.integer  "direct_medium_percent",         default: 0,         null: false
    t.integer  "organic_medium_percent",        default: 0,         null: false
    t.integer  "referral_medium_percent",       default: 0,         null: false
    t.integer  "advertising_percent",           default: 0,         null: false
    t.integer  "max_duration_scraping",         default: 1,         null: false
    t.integer  "min_count_page_advertiser",     default: 10,        null: false
    t.integer  "max_count_page_advertiser",     default: 15,        null: false
    t.integer  "min_duration_page_advertiser",  default: 60,        null: false
    t.integer  "max_duration_page_advertiser",  default: 120,       null: false
    t.integer  "percent_local_page_advertiser", default: 80,        null: false
    t.integer  "duration_referral",             default: 20,        null: false
    t.integer  "min_count_page_organic",        default: 4,         null: false
    t.integer  "max_count_page_organic",        default: 6,         null: false
    t.integer  "min_duration_page_organic",     default: 10,        null: false
    t.integer  "max_duration_page_organic",     default: 30,        null: false
    t.integer  "min_duration",                  default: 5,         null: false
    t.integer  "max_duration",                  default: 10,        null: false
    t.integer  "min_duration_website",          default: 10,        null: false
    t.integer  "min_pages_website",             default: 2,         null: false
    t.string   "state",                         default: "created", null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "execution_mode",                default: "auto",    null: false
  end

  add_index "traffics", ["website_id"], name: "index_traffics_on_website_id"

  create_table "visits", force: :cascade do |t|
    t.integer  "policy_id"
    t.string   "policy_type"
    t.string   "id_visit",                                        null: false
    t.datetime "start_time"
    t.string   "landing_url",                                     null: false
    t.string   "actions",                  default: "--- []\n",   null: false
    t.string   "referrer",                                        null: false
    t.string   "advert",                                          null: false
    t.string   "state",                    default: "created",    null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "execution_mode",           default: "auto",       null: false
    t.string   "browser_name",             default: "",           null: false
    t.string   "browser_version",          default: "",           null: false
    t.string   "operating_system_name",    default: "",           null: false
    t.string   "operating_system_version", default: "",           null: false
    t.integer  "count_browsed_page",       default: 0,            null: false
    t.datetime "end_time"
    t.datetime "plan_time"
    t.string   "ip_geo_proxy",             default: "no geo",     null: false
    t.string   "country_geo_proxy",        default: "no country", null: false
    t.string   "reason",                   default: "no reason",  null: false
    t.string   "keywords",                 default: "no keyword", null: false
  end

  add_index "visits", ["policy_type", "policy_id"], name: "index_visits_on_policy_type_and_policy_id"

  create_table "websites", force: :cascade do |t|
    t.string   "label",                                                       null: false
    t.string   "profil_id_ga",   default: "none",                             null: false
    t.string   "url_root",                                                    null: false
    t.integer  "count_page",     default: 0,                                  null: false
    t.string   "schemes",        default: "---\n- http\n- https\n",           null: false
    t.string   "types",          default: "---\n- local\n- global\n- full\n", null: false
    t.string   "advertisers",    default: "---\n- ''\n",                      null: false
    t.integer  "count_organic",  default: -1,                                 null: false
    t.integer  "count_referral", default: -1,                                 null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

end
