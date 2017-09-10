require 'suap'

class Room < ApplicationRecord
  include Hashid::Rails

  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :messages

  before_create :set_title

  validates :suap_id, :year, :semester, :curricular_component, presence: true

  def self.fetch_by_user(user)
    if user.student?
      SUAP::API.fetch_rooms_data_by_student(token: user.suap_token, year: 2017, semester: 1)
    else
      SUAP::API.fetch_rooms_data_by_professor(token: user.suap_token, year: 2017, semester: 1)
    end
  end

  def include?(user)
    self.users.include?(user)
  end

  def self.playground
    self.find_by_suap_id(1)
  end

  private

  def set_title
    self.title = self.curricular_component.split(" - ")[1] if title.nil?
  end

end
