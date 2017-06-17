require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should have_many(:subscriptions) }
  it { should have_many(:users) }
  it { should have_many(:messages) }

  it { should validate_presence_of(:suap_id) }
  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:semester) }
  it { should validate_presence_of(:curricular_component) }
end
