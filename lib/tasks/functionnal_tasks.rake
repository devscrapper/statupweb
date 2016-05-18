namespace :statupweb do
  task terminate_policy: :environment do
    desc "terminate policies which period is over"
    Traffic.terminate
    # Rank.terminate
    # SeaAttack.terminate
  end

end

# * 0 * * * cd /home/eric/statupweb && /usr/local/rvm/gems/ruby-2.2.3/bin/rake RAILS_ENV=production statupweb:terminate_policy
