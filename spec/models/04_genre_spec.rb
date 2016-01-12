require 'spec_helper'

describe "Genre" do
  before do 
    @user = User.create(:username => "Billy Bob", :password => "password")
    @movie = Movie.create(:name => "Grown Ups 2")
    @review = Review.create(:content => "Grown Ups 2 is a horrible movie", :user_id => @user.id, :movie_id => @movie.id)
    @genre = Genre.create(:name => "Comedy Action")

    @genre.movies << @movie 
  end

  it "can be initialized" do
    expect(@genre).to be_an_instance_of(Genre)
  end

  it "can have a name" do
    expect(@genre.name).to eq("Comedy Action")
  end

  it "can slugify it's name" do
    expect(@genre.slug).to eq("comedy-action")
  end

  it "has many movies" do
    expect(@genre.movies.count).to eq(1)
  end

  describe "Class methods" do
    it "given the slug can find a Genre" do
      slug = "comedy-action"
      expect((Genre.find_by_slug(slug)).name).to eq("Comedy Action")
    end
  end

end