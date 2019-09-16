require 'sinatra'
require 'pg'
require 'securerandom'
load 'lib/hackr_link.rb'
HackrLink::init

module HackrLink
  class Server < Sinatra::Base
    set :root, "#{File.dirname(__FILE__)}"

    db = PG.connect(
      :host => HackrLink::Config['database']['host'],
      :port => HackrLink::Config['database']['port'],
      :dbname => HackrLink::Config['database']['name'],
      :user => HackrLink::Config['database']['username'],
      :password => HackrLink::Config['database']['password']
    )

    get '/:token?' do
      redirect_url = 'http://The.CyberPul.se'
      token = params[:token].to_s

      unless token.empty?
        sql = 'SELECT * FROM links WHERE shortcode = $1;';
        query_name = "#{Time.now.to_i}-{SecureRandom.uuid}"
        db.prepare query_name, sql
        result = db.exec_prepared(query_name, [token])
        url = result.first['url'].to_s if result.count.positive?
        redirect_url = url if url.present?
      end

      redirect redirect_url
    end
  end
end
