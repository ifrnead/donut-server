require 'suap'
require 'errors'

class User < ApplicationRecord
  has_many :subscriptions
  has_many :rooms, through: :subscriptions
  has_many :messages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :encryptable

  validates :password, :username, :current_suap_token, :enroll_id, :name, :fullname, :url_profile_pic, presence: true

  before_create :new_token
  after_create :fetch_rooms
  before_save :update_suap_token_expiration_time, if: :current_suap_token_changed?

  PUBLIC_FIELDS = [ :id, :username, :name, :fullname, :url_profile_pic, :category ]

  def self.authenticate(username:, password:)
    user = User.find_by_username(username)

    if user and user.decrypted_password == password
      user
    else
      begin
        suap_token = SUAP::API.authenticate(username: username, password: password)
        user_data = SUAP::API.fetch_user_data(suap_token)
        user = User.create(
          username: user_data["matricula"],
          current_suap_token: suap_token,
          suap_id: user_data["id"],
          enroll_id: user_data["matricula"],
          name: user_data["nome_usual"],
          fullname: user_data["vinculo"]["nome"],
          url_profile_pic: user_data["url_foto_75x100"],
          category: user_data["tipo_vinculo"],
          email: user_data["email"],
          password: password
        )
        user
      rescue RestClient::BadRequest
        raise DonutServer::Errors::InvalidCredentialsError.new
      rescue RestClient::Unauthorized
        raise DonutServer::Errors::InvalidTokenError.new
      end
    end
  end

  def decrypted_password
    Devise::Encryptable::Encryptors::Aes256.decrypt(encrypted_password, Devise.pepper)
  end

  def valid_suap_token?
    DateTime.now > self.suap_token_expiration_time
  end

  def suap_token
    if not valid_suap_token?
      self.request_new_suap_token
    end
    self.current_suap_token
  end

  def request_new_suap_token
    begin
      new_suap_token = SUAP::API.authenticate(username: username, password: self.decrypted_password)
      self.update_attribute(:current_suap_token, new_suap_token)
    rescue RestClient::BadRequest
      raise DonutServer::Errors::InvalidCredentialsError.new
    end
  end

  def new_token
    token = nil
    loop do
      token = SecureRandom.hex(64)
      user = User.find_by_token(token)
      break if user.nil?
    end
    self.token = token
  end

  def public_fields
    fields = Hash.new
    PUBLIC_FIELDS.each do |public_field|
      fields[public_field] = self[public_field]
    end
    fields
  end

  def send_message(content:, room_id:)
    self.messages.create(content: content, room_id: room_id)
  end

  def employee?
    self.category == 'Servidor'
  end

  def student?
    self.category == 'Aluno'
  end

  private

  def fetch_rooms
    rooms = Room.fetch_by_user(self)
    self.rooms << rooms
  end

  def update_suap_token_expiration_time
    self.suap_token_expiration_time = DateTime.now + 1
  end

end
