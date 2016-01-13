class UserController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"users/signup"
    else
      @user = User.find(session[:id])
      redirect to "/#{user.slug}"
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
      redirect to "/#{user.slug}"
    end
  end

  get '/login' do 
    if !logged_in?
      erb :"users/login"
    else
      redirect to "/#{user.slug}"
    end
  end

  post '/login' do
    if params["username"].empty? || params["password"].empty?
      erb :"users/login", locals:{empty: "Please fill in all fields"}
    else
      user = User.find_by(username: params["username"])
      if !!user && user.authenticate(params["password"])
        session[:id] = user.id  
        redirect to "/#{user.slug}"
      else
        erb :"users/login", locals:{error: "Invalid username/password"}
      end
    end
  end

  get '/logout' do 
    session.clear
    redirect to '/'
  end

  get '/:slug' do
    redirect to "/login" if !logged_in? 
    @user = User.find_by_slug(params[:slug])
    @reviews = @user.reviews
    erb :"users/index"
  end

  get '/:slug/reviews' do
    redirect to "/login" if !logged_in?
    @user = User.find_by_slug(params[:slug])
    @reviews = @user.reviews
    erb :"reviews/show"
  end

  get '/:slug/reviews/:id' do
    redirect to "/login" if !logged_in?
    @review = User.reviews[params[:id].to_i-1]
    erb :"/reviews/post"
  end

  get '/:slug/reviews/:id/edit' do
    redirect to "/login" if !logged_in?
    @user = User.find_by_slug(params[:slug])
    redirect to "/#{user.slug}" if @user.id != session[:id]
    @review = @user.reviews[params[:id].to_i-1]
    erb :"reviews/edit"
  end

  post '/:slug/reviews/:id' do
    redirect to "/login" if !logged_in?
    @user = current_user
    @review = @user.reviews[params[:id].to_i-1]
    @review.content = params["content"]
    @review.year = params["year"].to_i
    @review.score = params["score"].to_i
    @review.update
    redirect to "/#{@user.slug}/reviews/#{params[:id]}"
  end

  post '/:slug/reviews/:id/delete' do
    redirect to "/login" if !logged_in?
    @user = User.find_by_slug(params[:slug])
    @review = User.reviews[params[:id].to_i-1]
    @review.destroy
    redirect to '/:slug/reviews/'
  end
end