require 'spec_helper'

describe UserController do
  describe "Signup Page" do 
    
    it 'loads the signup page' do 
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to Reel Reviews index' do 
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
end