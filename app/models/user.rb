require 'suap'
require 'errors'

class User < ApplicationRecord
  has_many :subscriptions
  has_many :rooms, through: :subscriptions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :encryptable

  before_create :new_token

  PUBLIC_FIELDS = [ :id, :username, :name, :fullname, :url_profile_pic, :category ]

  def self.authenticate(username:, password:)
    user = User.find_by_username(username)

    if user and user.decrypted_password == password
      user
    else
      begin
        token = SUAP::API.authenticate(username: username, password: password)
        user_data = SUAP::API.fetch_user_data(token)
        user = User.create(
          username: user_data["matricula"],
          suap_token: token,
          suap_token_expiration_date: Date.tomorrow,
          suap_id: user_data["id"],
          enroll_id: user_data["matricula"],
          name: user_data["nome_usual"],
          fullname: user_data["vinculo"]["nome"],
          url_profile_pic: user_data["url_foto_75x100"],
          category: user_data["vinculo"]["categoria"],
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
    Date.today > self.suap_token_expiration_date
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

end
