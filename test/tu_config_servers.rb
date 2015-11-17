require "../lib/servers"
# OUT OF RAILS
my_servers = Servers.new("D:/referentiel/dev/statupweb/config/servers.yml", "development")
p my_servers["engine_bot"]["ip"]

# IN Rails
server = Servers.new()
p server["engine_bot"]["ip"]