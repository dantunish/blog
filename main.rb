require 'sinatra'
require "sinatra/reloader"
# Run this script with `bundle exec ruby app.rb`

require 'active_record'
#require classes
require './models/user.rb'
require './models/blog.rb'
# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
require 'csv'
# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes

if ENV['DATABASE_URL']
  require 'pg'
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  require 'sqlite3'
  ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/xeni.db'
)
end
register Sinatra::Reloader
enable :sessions

# WELCOME PAGE
get '/' do
  if session[:user_id]
    redirect '/account'
  else
  @Blogs_all = Blog.all.reverse
  erb :welcome, :layout => :layout
  end
end

# SIGNUP
get '/signup' do
  if session[:user_id]
    redirect '/account'
  else
  erb :signup, :layout => :layout
  end
end

post '/signup' do
  temp_user = User.find_by(email: params["email"])
  if temp_user
    redirect '/already'
  else
    user = User.create(nickname: params["nickname"], email: params["email"], password: params["password"])
    session[:user_id] = user.id
    redirect '/account'
  end
end

get '/already' do
  erb :already, :layout => :layout
end

# LOGIN
get '/login' do
  if session[:user_id]
    redirect '/account'
  else
  erb :login, :layout => :layout
  end
end

post '/login' do
  user = User.find_by(email: params["email"], password: params["password"])
  if user
    session[:user_id] = user.id
    redirect '/account'
  else
    redirect '/login'
  end
end

# ACCOUNT PAGE
get '/account' do
  @Blogs_all = Blog.all.reverse
  erb :account, :layout => :lay
end

post '/blogpost' do
  Blog.create(title: params[:title], post: params[:post])
  redirect '/account'
end

# SIGNOUT
get '/signout' do
  session[:user_id] = nil
  redirect '/'
  
end
#Delete
get '/delete' do
  des_user=User.find(session[:user_id])
  session[:user_id] = nil
  des_user.destroy
  redirect '/'
end
# binding.pry

