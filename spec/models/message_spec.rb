require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:user).dependent(:destroy) }
  it { should belong_to(:room) }

  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:room_id) }
end
