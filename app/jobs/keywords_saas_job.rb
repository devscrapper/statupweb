require_relative '../../lib/extern_uri'

class KeywordsSaasJob < ActiveJob::Base
  queue_as :default


  rescue_from(Exception) do |exception|
    $stderr << "rescue_from #{exception.message}\n"
  end

  def perform (website)
    $stderr << "perform  #{website.label}\n"
    count = ExternUri::count_keywords(website.url_root)
    $stderr << "count  #{count}\n"
    website.count_organic = count
    website.save
  end


end
