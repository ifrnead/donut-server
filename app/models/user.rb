
class User < ApplicationRecord
  include SUAP::API

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :encryptable

  def self.find_or_create_by_credentials(username:, password:)
    user = User.find_by_enroll_id(username)

    if user.nil?
      token = authenticate(username: username, password: password)
      user_data = fetch_user_data(token)
      user = User.create(
        username: user_data["matricula"],
        suap_token: token,
        suap_id: user_data["id"],
        enroll_id: user_data["matricula"],
        name: user_data["nome_usual"],
        fullname: user_data["vinculo"]["nome"],
        url_profile_pic: user_data["url_foto_75x100"],
        category: user_data["vinculo"]["categoria"],
        email: user_data["email"],
        password: password
      )
    end

    user
  end

  def decrypted_password
    Devise::Encryptable::Encryptors::Aes256.decrypt(encrypted_password, Devise.pepper)
  end

end
