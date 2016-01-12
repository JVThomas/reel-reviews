require 'spec_helper'

describe "User" do
  before do 
    @user = User.create(:username => "Billy Bob", :password => "password")
    @movie = Movie.create(:name => "Grown-Ups 2")
    @review = Review.create(:content => "Grown-Ups 2 is a horrible movie", :user_id => @user.id, :movie_id => @movie.id)
  end

  it "can be initialized" do
    expect(@user).to be_an_instance_of(User)
  end

  it "can have a name" do
    expect(@user.username).to eq("Billy Bob")
  end

  it "can slugify it's name" do

    expect(@user.slug).to eq("billy-bob")
  end

  it "can have many reviews" do
    expect(@user.reviews.count).to eq(1)
  end

  it "has seen many movies though reviews" do 
    expect(@user.movies.count).to eq(1)
  end

  describe "Class methods" do
    it "given the slug can find a User" do
      slug = "billy-bob"
      expect((User.find_by_slug(slug)).username).to eq("Billy Bob")
    end
  end

end