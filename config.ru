##########
# config.ru
#

require File.dirname(__FILE__) + '/app/server.rb'

run HackrLink::Server
