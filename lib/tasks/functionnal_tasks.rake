namespace :statupweb do
  task terminate_policy: :environment do
    desc "terminate policies which period is over"
    Traffic.terminate
    Rank.terminate
    SeaAttack.terminate
  end

end

# ajouter la ligne suivante dans le fuchier de cron au moyen de la commande crontab -e
# ctrl-O pour sauver
# ctrl-X pour sortir
# * 0 * * * cd /home/eric/statupweb && /usr/local/rvm/gems/ruby-2.2.3/bin/rake RAILS_ENV=production statupweb:terminate_policy
