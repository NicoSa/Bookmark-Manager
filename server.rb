require 'sinatra'
require 'sinatra/base'



require 'rack-flash'
require_relative './helpers/current_user.rb'
require_relative './helpers/datamapper_setup.rb'
require_relative './lib/email_controller.rb'

include Email

use Rack::Flash

enable :sessions
set :session_secret, 'super secret'

get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag|
    Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
    @user = User.new
    erb :'users/new'
end

post '/users' do
  @user = User.create(:email => params[:email],
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to ('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  @user = User.authenticate(email, password)
  if @user
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password is incorrect"]
    erb :"sessions/new"
  end
end

delete '/sessions' do
  session[:user_id] = nil
  "Good bye!"
end

get '/forgotten_password' do
  erb :forgotten_password
end

post '/forgotten_password' do
  user = User.first(:email => params[:email])
  #raise "This email doesn´t exist in our database" if user == nil
  begin
    user.email == params[:email]
    generated_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token = generated_token
    user.password_token_timestamp = Time.now
    user.save
    "no error"
  rescue
    "This user doesn´t exist!"
  end

end

get '/reset_password/:token' do
  user = User.first(:password_token => token)
  user.password_token_timestamp 
  send_simple_message
  erb :"users/reset_password"
end

post '/reset_password' do

end
