class ReviewController < ApplicationController

  get '/reviews' do 
    @reviews = Reviews.all
    erb :"reviews/show"
  end

  get '/reviews/:id' do
    @review = Review.find(params[:id])
    erb :"/reviews/post"
  end

  get '/reviews/:id/edit' do
    redirect to "/login" if !logged_in?
    @review = Review.find(params[:id])
    redirect to "/reviews" if @review.user_id != session[:id]
    erb :"reviews/edit"
  end

  get '/reviews/new' do
    redirect to "/login" if !logged_in?
    erb :"reviews/new"
  end

  post '/reviews' do
    @review = Review.create(content: params["content"], score: params["score"].to_i)
    redirect to "/reviews"
  end

  post '/reviews/:id' do
    redirect to "/login" if !logged_in?
    @review = Review.find(params[:id])
    redirect to "/reviews" if @review.user_id != session[:id]
    @review.content = params["content"]
    @review.year = params["year"].to_i
    @review.score = params["score"].to_i
    @review.update
    redirect to "/reviews/#{@review.id}"
  end

  post '/reviews/:id/delete' do
    redirect to "/login" if !logged_in?
    @review = User.reviews[params[:id].to_i-1]
    redirect to "/reviews" if @review.user_id != session[:id]
    @review.destroy
    redirect to '/reviews'
  end

end