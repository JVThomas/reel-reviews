require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "upupdowndownleftrightleftrightabselectstart"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if !logged_in?
      erb :"users/signup"
    else
      redirect "/homepage"
    end
  end

  post '/signup' do
    user = User.new(username: params["username"], password: params["password"])
    if params["username"].empty? || params["password"].empty?
      redirect to "/signup", locals[:empty] ="Please fill in all fields"   
    elsif !!User.find_by(name: user.name)
      redirect to "/signup", locals[:taken] = "Username already taken"
    else
      session[:id] = user.id
      user.save
      redirect to "/homepage"
    end
  end

  get '/login' do 
    if !logged_in?
      erb :"users/login"
    else
      redirect to '/homepage'
    end
  end

  post '/login' do
    if params["username"].empty? || params["password"].empty?
      redirect to "/login", locals[:empty] = "Please fill in all fields"
    else
      user = User.find_by(username: params["username"])
      if !!user && user.authenticate(params["password"])
        session[:id] = user.id  
        redirect to "/homepage"
      else
        redirect to "/login", locals[:error]= "Incorrect username/password"
      end
    end
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

end