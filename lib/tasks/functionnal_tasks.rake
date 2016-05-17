namespace :statupweb do
  task terminate_policy: :environment do
    desc "terminate policies which period is over"
    Traffic.terminate
    # Rank.terminate
    # SeaAttack.terminate
  end

end
