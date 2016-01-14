class ReviewController < ApplicationController

  get '/reviews' do 
    @movies = Movie.all.order(name: :asc)
    erb :"reviews/index"
  end

  get 'reviews/movies' do
    redirect to '/reviews'
  end

  get '/reviews/new' do
    redirect to "/login" if !logged_in?
    erb :"reviews/new"
  end

  post '/reviews' do
    if params[:name].empty? || params[:score].empty? || params[:content].empty?
      erb :"reviews/new", locals:{empty: "Please fill in all fields"}
    else
      @movie = Movie.find_or_create_by(name: params["name"])
      @review = Review.create(content: params["content"], score: params["score"], user_id: session[:id], movie_id: @movie.id)
      redirect to "/reviews/movies/#{@movie.slug}"
    end
  end

  get "/reviews/movies/:slug" do
    @session = session[:id]
    @movie = Movie.find_by_slug(params[:slug])
    @reviews = @movie.reviews.order(id: :desc)
    erb :"reviews/show"
  end

  get "/reviews/movies/:slug/:id" do
    @review = Review.find(params[:id])
    erb :"/reviews/post"
  end

  get "/reviews/movies/:slug/:id/edit" do
    redirect to "/login" if !logged_in?
    @review = Review.find(params[:id])
    redirect to "/reviews" if @review.user_id != session[:id]
    erb :"reviews/edit"
  end

  post '/reviews/movies/:slug/:id' do
    redirect to "/login" if !logged_in?
    if params["name"].empty? || params["score"].empty? || params["content"].empty?
      erb :"reviews/new", locals:{empty: "Please fill in all fields"}
    end
    @review = Review.find(params[:id])
    redirect to "/reviews" if @review.user_id != session[:id]
    @review.content = params["content"]
    @review.score = params["score"]
    @review.update
    redirect to "/reviews/movies/#{params[:slug]}"
  end

  post "/home/:id" do
    redirect to "/login" if !logged_in?
    @review = Review.find(params[:id])
    redirect to "/home" if @review.user_id != session[:id]
    @review.destroy
    redirect to '/home'
  end

  post "/reviews/movies/:slug/:id/delete" do
    redirect to "/login" if !logged_in?
    @review = Review.find(params[:id])
    redirect to "/home" if @review.user_id != session[:id]
    @review.destroy
    redirect to "/reviews/movies/#{params[:slug]}"
  end

  helpers do
    def review_owner(review)
      User.find(review.user_id)
    end
  end

end