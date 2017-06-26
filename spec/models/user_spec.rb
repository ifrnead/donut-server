require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :subscriptions }
  it { should have_many :rooms }
  it { should have_many :messages }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :username }
  it { should validate_presence_of :current_suap_token }
  it { should validate_presence_of :enroll_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :fullname }
  it { should validate_presence_of :url_profile_pic }
  it { should validate_presence_of :category }
end
