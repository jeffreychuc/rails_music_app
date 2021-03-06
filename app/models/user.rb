# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, :password_digest, :session_token, presence: true
  # only allows password to be nil or be present, an empty string "" is not nill
  validates :password, length: {minimum: 6, allow_nil: true}
  # this line runs ensure_session_token after the user is generated
  after_initialize :ensure_session_token
  attr_reader :password

  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = generate_session_token
    # needs save
    self.save!
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
    #doesnt need a save because of line under validates
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil if user.nil?
    if BCrypt::Password.new(user.password_digest).is_password?(password)
      return user
    end
  end
end
