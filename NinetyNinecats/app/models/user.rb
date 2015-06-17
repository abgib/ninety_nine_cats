# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :text             not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, :session_token, uniqueness: true

  before_save do
    redirect_to cats_url if !current_user
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest)
      .is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    current_user = User.find_by(user_name: user_name)

    if current_user.is_password?(password)
      current_user
    else
      nil
    end
  end

end
