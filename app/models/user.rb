class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_or_create(user_data:, token:)
    user = User.find_by_enroll_id(user_data["matricula"])
    if user.nil?
      user = User.new(
        username: user_data["matricula"],
        suap_token: token,
        suap_id: user_data["id"],
        enroll_id: user_data["matricula"],
        name: user_data["nome_usual"],
        fullname: user_data["vinculo"]["nome"],
        url_profile_pic: user_data["url_foto_75x100"],
        category: user_data["vinculo"]["categoria"],
        email: user_data["email"]
      )
      user.save(validate: false)
    end
    user
  end

end
