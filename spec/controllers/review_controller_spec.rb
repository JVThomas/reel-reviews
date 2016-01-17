require 'spec_helper'
require 'pry'

describe ReviewController do
  
  describe "Create - Review" do
    context "logged in" do
      it "loads the new review form when logged in" do
        user = User.create(:username => "becky567", :password => "kittens")
        params = {
          :username => "becky567",
          :password => "kittens"
        }
        post '/login', params
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)

        get '/reviews/new'
        expect(last_response.status).to eq (200)
      end

      it "lets user create a new review if logged in" do
        user = User.create(:username => "becky567", :password => "kittens")
        params = {
          :username => "becky567",
          :password => "kittens"
        }
        post '/login', params
        expect(last_response.status).to eq(302)
        follow_redirect!
        expect(last_response.status).to eq(200)
        
        visit '/reviews/new'
        fill_in(:name, :with => "Movie")
        fill_in(:score, :with => "10/10")
        fill_in(:content, :with => "Amazing movie")
        click_button 'Create'
        review = Review.find_by(name: "Movie", user_id: session[:id])
        expect(review).to be_instance of(Review)
        expect(page.status_code).to eq(200)
      end
    end
  
  end
end