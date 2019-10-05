require 'pg'
require 'securerandom'
load 'lib/hackr_link.rb'
HackrLink::init

db = PG.connect(
  :host => HackrLink::Config['database']['host'],
  :port => HackrLink::Config['database']['port'],
  :dbname => HackrLink::Config['database']['name'],
  :user => HackrLink::Config['database']['username'],
  :password => HackrLink::Config['database']['password']
)

legal_characters = %i{a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0}

permutations = legal_characters.permutation(3).to_a

sql = 'INSERT INTO links (shortcode, url, created_at, updated_at) VALUES ($1, $2, NOW(), NOW());'

permutations.each do |permutation|
  query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
  db.prepare query_name, sql
  shortcode = permutation.join('')
  if shortcode == 'bio'
    db.exec_prepared(query_name, ['bio', 'http://The.CyberPul.se/bio'])
  else
    db.exec_prepared(query_name, [permutation.join(''), ''])
  end
end

# hackr.link/yt
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['yt', 'https://youtube.com/channel/UCU6TswZ2C-QJ3jgf5ujhHNw']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/youtube
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['youtube', 'https://youtube.com/channel/UCU6TswZ2C-QJ3jgf5ujhHNw']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/twitter
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['twitter', 'https://twitter.com/TheCyberPulse']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/twitter
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['twitter', 'https://twitter.com/TheCyberPulse']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/instagram
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['instagram', 'https://instagram.com/TheCyberPulse']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/ig
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['ig', 'https://instagram.com/TheCyberPulse']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/xeraen
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['xeraen', 'http://xeraen.com']
db.prepare query_name, sql
db.exec_prepared query_name, values

# hackr.link/x
query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
values = ['x', 'http://xeraen.com']
db.prepare query_name, sql
db.exec_prepared query_name, values
