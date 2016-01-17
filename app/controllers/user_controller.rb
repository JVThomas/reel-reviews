class UserController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"users/signup"
    else
      redirect to '/home'
    end
  end

  post '/signup' do
    user = User.new(username: params["username"], password: params["password"])
    if params["username"].empty? || params["password"].empty?
      erb :"users/signup", locals:{empty: "Please fill in all fields"}  
    elsif !!User.find_by(username: user.username)
      erb :"users/signup", locals:{taken: "Username already taken"}
    else
      user.save
      session[:id] = user.id
      redirect to "/home"
    end
  end

  get '/login' do 
    if !logged_in?
      erb :"users/login"
    else
      redirect to "/home"
    end
  end

  post '/login' do
    if params["username"].empty? || params["password"].empty?
      erb :"users/login", locals:{empty: "Please fill in all fields"}
    else
      user = User.find_by(username: params["username"])
      if !!user && user.authenticate(params["password"])
        session[:id] = user.id  
        redirect to "/home"
      else
        erb :"users/login", locals:{error: "Invalid username/password"}
      end
    end
  end

  get '/logout' do 
    redirect to '/' if !logged_in?
    session.clear
    redirect to '/'
  end

  get '/users' do
    redirect to "/login" if !logged_in?
    @users = User.all.order(username: :asc)
    erb :"users/index"
  end

  get '/users/:slug' do
    redirect to "/login" if !logged_in? 
    @user = User.find_by_slug(params[:slug])
    redirect to "/home" if @user == current_user
    @reviews = @user.reviews
    erb :"users/show"
  end

  get '/home' do
    redirect to "/login" if !logged_in? 
    @user = current_user
    @reviews = @user.reviews
    erb :"users/home"
  end

  helpers do
    def movie_reviewed(review)
      Movie.find(review.movie_id)
    end
  end
end