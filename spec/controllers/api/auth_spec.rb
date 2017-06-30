require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  it "provides valid credentials" do
    post :auth, params: { user: { username: Rails.application.secrets.username, password: Rails.application.secrets.password } }

    expect(response).to be_success
    expect(User.first.username).to eq Rails.application.secrets.username
    expect(User.first.token).to eq json_response["token"]
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
