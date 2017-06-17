require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:author).dependent(:destroy) }
  it { should belong_to(:receiver) }
  
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:author_id) }
  it { should validate_presence_of(:receiver_type) }
  it { should validate_presence_of(:receiver_id) }
end
