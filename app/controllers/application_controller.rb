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

  get "/movies" do
    @movies = Movie.all
    erb :"movies/index"
  end

  get "/movies/:id" do
    @movie = Movie.find(params[:id])
    @reviews = Review.all
    erb :"movies/show"
  end

  get "/genres" do
    @genres = Genre.all
    erb :"genres/index"
  end

  get "/genre/:slug" do
    @genre = Genre.find_by_slug(params[:slug])
    @movies = @genre.movies
    erb :"genre/show"
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