require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require_relative './helpers/current_user.rb'
require_relative './lib/datamapper_setup.rb'
require_relative './lib/email_controller.rb'

include Email
include BCrypt

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
  #find user by email
  user = User.first(:email => params[:email])
  begin
    #is email and database email identical?
    user.email == params[:email]
    email = user.email
    generated_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token = generated_token
    user.password_token_timestamp = Time.now
    user.save
    #send email with token and link
    send_recovery_email(generated_token,email)
  rescue
    'This user doesn´t exist! <a href="/forgotten_password">Back</a>'
  end

end

get '/reset_password/:token' do
  user = User.first(:password_token => params[:token])
  begin 
    user.password_token == params[:token]
    @token = params[:token]
    erb :"users/reset_password"
  rescue
    'Token has already been used'
  end
end

post '/reset_password' do
  begin      
      #checks for identical password"
      params[:password] == params[:password_confirmation]
      #find User by token
      user = User.first(:password_token => params[:token])
      #set new password and hash it
      user.password_digest = BCrypt::Password.create(params[:password])
      #set token and timestamp nil
      user.password_token = nil
      user.password_token_timestamp = nil
      #save changes
      user.save
      "All done, you can login with your new password now"
  rescue
    "Something wasn´t quite right, try again or request a new token"
  end

end
