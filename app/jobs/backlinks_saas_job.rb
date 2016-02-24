require_relative '../../lib/extern_uri'

class BacklinksSaasJob < ActiveJob::Base
  queue_as :backlinks

  rescue_from(Exception) do |exception|
    $stderr << "rescue_from #{exception.message}\n"
  end

  def perform (website)
    $stderr << "perform  #{website.label}\n"
    count = ExternUri::count_backlinks(website.url_root)
    $stderr << "count  #{count}\n"
    website.count_referral = count
    website.save
  end
end
