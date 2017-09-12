require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  it "provides valid credentials" do
    post :auth, params: { user: { username: Rails.application.secrets.professor_username, password: Rails.application.secrets.professor_password } }

    user = User.find_by_username(Rails.application.secrets.professor_username)

    expect(response).to be_success
    expect(user.username).to eq user.username
    expect(user.token).to eq json_response["token"]
    expect(response.content_type).to eq "application/json"
  end

  it "provides invalid credentials" do
    post :auth, params: { user: { username: "invalid_user", password: "invalid_pass" } }

    expect(response).to be_unauthorized
    expect(response.content_type).to eq "application/json"
    expect(json_response["message"]).to eq "invalid_credentials"
  end

  it "doesn't provide credentials" do
    post :auth

    expect(response).to be_unauthorized
    expect(response.content_type).to eq "application/json"
    expect(json_response["message"]).to eq "invalid_credentials"
  end
end
