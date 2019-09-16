require 'pg'
load 'lib/hackr_link.rb'
HackrLink::init

db = PG.connect(
  :host => HackrLink::Config['database']['host'],
  :port => HackrLink::Config['database']['port'],
  :dbname => HackrLink::Config['database']['name'],
  :user => HackrLink::Config['database']['username'],
  :password => HackrLink::Config['database']['password']
)

files = Dir.glob('db/sql/**/*.sql').sort_by {|f| File.mtime(f)}

files.each do |sql_file|
  sql = File.open(sql_file) {|file| file.read}
  db.exec sql
end
