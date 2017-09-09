require 'rails_helper'

RSpec.describe "Rooms API", type: :request do

  before do
    post '/api/auth', params: { user: { username: Rails.application.secrets.professor_username, password: Rails.application.secrets.professor_password } }
    @user = User.first
    @headers = { 'Authorization' => "Token #{@user.token}" }
  end

  it "retrieves rooms list" do
    get '/api/rooms', headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(JSON.parse(response.body).size).to eq(@user.rooms.size)
  end

  it "retrieves room details" do
    room = @user.rooms.first
    get "/api/rooms/#{room.id}", headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(response.body).to eq(room.to_json)
  end

  it "tries to retrieve nonexistent room details" do
    get "/api/rooms/9999999999", headers: @headers

    expect(response).to be_not_found
  end

  it "tries to retrieve room details which the user isn't included" do
    room = create(:room)
    get "/api/rooms/#{room.id}", headers: @headers

    expect(response).to be_unauthorized
  end

  it "try to use the API without token" do
    get '/api/rooms'
    expect(response).to be_unauthorized

    get "/api/rooms/#{Room.first.id}"
    expect(response).to be_unauthorized
  end

end
