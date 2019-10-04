require 'sinatra'
require 'pg'
require 'securerandom'
load 'lib/hackr_link.rb'
HackrLink::init
configure { set :server, :puma }

module HackrLink
  class Server < Sinatra::Base
    enable :inline_templates
    enable :sessions

    set :root, "#{File.dirname(__FILE__)}"

    db = PG.connect(
      :host => HackrLink::Config['database']['host'],
      :port => HackrLink::Config['database']['port'],
      :dbname => HackrLink::Config['database']['name'],
      :user => HackrLink::Config['database']['username'],
      :password => HackrLink::Config['database']['password']
    )

    User = Struct.new(:id, :username, :password)
    USERS = [
      User.new(1, HackrLink::Config['authentication']['ryker']['username'], HackrLink::Config['authentication']['ryker']['password']),
      User.new(2, HackrLink::Config['authentication']['xeraen']['username'], HackrLink::Config['authentication']['xeraen']['password'])
    ]

    ##########################################################################
    # Web UI
    ##########################################################################

    get '/login' do
      erb :login
    end

    post '/login' do
      user = USERS.find { |u| u.username == params[:username] }
      if user && (params[:password] == user.password)
        session.clear
        session[:user_id] = user.id
        redirect '/add_link'
      else
        @error = 'Username or password was incorrect'
        erb :login
      end
    end

    get '/add_link' do
      if current_user
        erb :add_link
      else
        redirect '/login'
      end
    end

    post '/add_link' do
      new_link_url = params[:new_link_url].to_s
      redirect '/add_link' if new_link_url.empty?

      select_sql = "SELECT * FROM links WHERE url IS NULL OR url = '' LIMIT 1;";
      query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
      db.prepare query_name, select_sql
      record = db.exec_prepared(query_name, []).first

      update_sql = 'UPDATE links SET url = $1 WHERE id = $2;'
      query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
      db.prepare query_name, update_sql
      result = db.exec_prepared(query_name, [new_link_url, record['id'].to_i])

      if result
        url = "https://#{HackrLink::Config['system']['domain']}/#{record['shortcode']}"
      else
        @error = 'Could not create link'
      end

      erb :add_link
    end

    post '/logout' do
      session.clear
      redirect '/login'
    end

    ##########################################################################
    # Actual hackr.link Functionality
    ##########################################################################

    get '/:token?' do
      redirect_url = 'http://The.CyberPul.se'
      token = params[:token].to_s

      unless token.empty?
        sql = 'SELECT * FROM links WHERE shortcode = $1;';
        query_name = "#{Time.now.to_i}-#{SecureRandom.uuid}"
        db.prepare query_name, sql
        result = db.exec_prepared(query_name, [token])
        url = result.first['url'].to_s if result.count.positive?
        redirect_url = url if url.present?
      end

      redirect redirect_url
    end

    helpers do
      def current_user
        return nil unless session[:user_id]
        USERS.find { |u| u.id == session[:user_id] }
      end
    end
  end
end

__END__

@@ login
  <h1>Login</h1>
  <% if @error %>
    <p class="error"><%= @error %></p>
  <% end %>
  <form action="/login" method="POST">
    <input name="username" placeholder="Username" />
    <input name="password" type="password" placeholder="Password" />
    <input type="submit" value="Login" />
  </form>

@@ add_link
  <h1>Add Link</h1>
  <p>Hello, <%= current_user.username %>.</p>
  <form action="/logout" method="POST">
    <input type="submit" value="Logout" />
  </form>

  <% if url %>
    <ul>
      <li><a href="<%= url %>" target="_blank"><%= url%></a></li>
    </ul>
  <% end %>

  <h2>Add New Link</h2>
  <form action="/add_link" method="POST">
    <input name="new_link_url" placeholder="URL" />
    <input type="submit" value="Add Link" />
  </form>

@@ layout
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8" />
      <title>Simple Authentication Example</title>
      <style>
        input { display: block; }
        .error { color: red; }
      </style>
    </head>
    <body><%= yield %></body>
  </html>
