require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "upupdowndownleftrightleftrightabselectstart"
  end

  get '/' do
    redirect to '/home' if logged_in?
    erb :index
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