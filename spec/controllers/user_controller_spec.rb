require 'spec_helper'

describe UserController do
  describe "Signup Page" do 
    
    it 'loads the signup page' do 
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to Reel Reviews home' do 
      params = {
        :username => "skittles123",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include("/home") 
    end

    it 'does not let a user sign up without a username' do 
      params = {
        :username => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.body).to include('Please fill in all fields')
    end

    it 'does not let a user sign up without a password' do 
      params = {
        :username => "skittles123",
        :password => ""
      }
      post '/signup', params
      expect(last_response.body).to include('Please fill in all fields')
    end
  end


  describe "login" do 
    it 'loads the login page' do
      get '/login' 
      expect(last_response.status).to eq(200)
    end

    it 'loads the user homepage after login' do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do 
      user = User.create(:username => "becky567", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/home")
    end
  end

  describe "logout" do 
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/")

    end
    it 'does not let a user logout if not logged in' do 
      get '/logout' 
      expect(last_response.location).to include("/")
    end

    it 'does not load /home if user not logged in' do 
      get '/home'
      expect(last_response.location).to include("/login")
    end 

    it 'does load /home if user is logged in' do
      user = User.create(:username => "becky567", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'Submit'
      expect(page.current_path).to eq('/home')


    end
  end

  describe 'user show page' do 
    it 'shows all a single users reviews' do
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      user = User.create(:username => "becky567", :password => "kittens")
      movie1 = Movie.create(name: "movie1")
      movie2 = Movie.create(name: "movie2")
      review1 = Review.create(:content => "Good!", :user_id => user.id, :movie_id => movie1.id)
      review2 = Review.create(:content => "Bad!", :user_id => user.id, :movie_id => movie2.id)
      
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      
      get "/users/#{user.slug}"
      expect(last_response.status).to eq(302)
      follow_redirect!

      expect(last_response.body).to include("Good!")
      expect(last_response.body).to include("Bad!")

    end
  end

  #Test keeps failing, but user index displays through shotgun, Sinatra logs reflect this as well
  describe 'index action' do 
    context 'logged in' do 
      it 'lets a user view the user index if logged in' do

      user = User.create(:username => "becky567", :password => "kittens")
      user2 = User.create(:username => "mikejordan", :password => "fly")
       params = {
        :username => "becky567",
        :password => "kittens"
      }

      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
       
      get "/users"
        expect(last_response.location).to eq("/users")
      end
    end

    context 'logged out' do 
      it 'does not let a user view the user index if not logged in' do 
        get '/users'
        expect(last_response.location).to include("/login")
      end
    end
  end
end


