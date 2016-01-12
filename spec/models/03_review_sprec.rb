require 'spec_helper'

describe "Review" do
  before do 
    @user = User.create(:username => "Billy Bob", :password => "password")
    @movie = Movie.create(:name => "Grown Ups 2")
    @review = Review.create(:content => "Grown Ups 2 is a horrible movie", :score => 1, :user_id => @user.id, :movie_id => @movie.id)
    @genre = Genre.create(:name => "Comedy")

  end

  it "can be initialized" do
    expect(@review).to be_an_instance_of(Review)
  end

  it "can have content" do
    expect(@review.content).to eq("Grown Ups 2 is a horrible movie")
  end

  it "can have a score" do
    expect(@review.score).to eq(1)
  end

  it "belongs to a user" do
    expect(@review.user_id).to eq(@user.id)
  end

  it "belongs to a movie" do 
    expect(@review.movie_id).to eq(@movie.id)
  end

end