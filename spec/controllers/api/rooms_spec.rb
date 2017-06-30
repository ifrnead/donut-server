require 'rails_helper'

RSpec.describe "Rooms API", type: :request do

  before do
    post '/api/auth', params: { user: { username: Rails.application.secrets.username, password: Rails.application.secrets.password } }
    @user = User.first
    @headers = { 'Authorization' => "Token #{@user.token}" }
  end

  it "retrieves rooms list" do
    get '/api/rooms', headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(JSON.parse(response.body).size).to eq(@user.rooms.size)
  end

  it "try to use the API without token" do
    get '/api/rooms'
    expect(response).to be_unauthorized

    get "/api/rooms/#{room.id}"
    expect(response).to be_unauthorized
  end

end
