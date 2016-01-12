require 'spec_helper'

describe "Movie" do
  before do 
    @user = User.create(:username => "Billy Bob", :password => "password")
    @movie = Movie.create(:name => "Grown Ups 2")
    @review = Review.create(:content => "Grown Ups 2 is a horrible movie", :user_id => @user.id, :movie_id => @movie.id)
    @genre = Genre.create(:name => "Comedy")

    @movie.genres << @genre 
  end

  it "can be initialized" do
    expect(@movie).to be_an_instance_of(Movie)
  end

  it "can have a name" do
    expect(@movie.name).to eq("Grown Ups 2")
  end

  it "can slugify it's name" do
    expect(@movie.slug).to eq("grown-ups-2")
  end

  it "can have many reviews" do
    expect(@movie.reviews.count).to eq(1)
  end

  it "has many viewers(users) through reviews" do 
    expect(@movie.users.count).to eq(1)
    expect(@movie.users.first.username).to eq("Billy Bob")
  end

  it "has many genres" do
    expect(@movie.genres.count).to eq(1)
  end

  describe "Class methods" do
    it "given the slug can find a User" do
      slug = "grown-ups-2"
      expect((Movie.find_by_slug(slug)).name).to eq("Grown Ups 2")
    end
  end

end