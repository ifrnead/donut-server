require 'rails_helper'

RSpec.describe "Users API", type: :request do

  before do
    post '/api/auth', params: { user: { username: Rails.application.secrets.username, password: Rails.application.secrets.password } }
    @user = User.first
    @headers = { 'Authorization' => "Token #{@user.token}" }
  end

  it "retrieves personal data" do
    get '/api/users/me', headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(response.body).to eq(@user.to_json)
  end

  it "retrieves user details" do
    get "/api/users/#{@user.id}", headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(response.body).to eq(User.select(User::PUBLIC_FIELDS).find(@user.id).to_json)
  end

  it "retrieves user list" do
    get "/api/users", headers: @headers

    expect(response).to be_success
    expect(response.content_type).to eq "application/json"
    expect(JSON.parse(response.body).size).to eq(User.count)
  end

  it "try to use the API without token" do
    get '/api/users/me'
    expect(response).to be_unauthorized

    get "/api/users/#{@user.id}"
    expect(response).to be_unauthorized

    get "/api/users"
    expect(response).to be_unauthorized
  end

end
