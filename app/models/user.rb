class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  scope :admins, -> { where(admin: true) }

  def generate_reset_password_token
    token = SecureRandom.urlsafe_base64(32)
    update!(reset_password_token: token, reset_password_sent_at: Time.current)
    token
  end

  def reset_password_token_expired?
    reset_password_sent_at.nil? || reset_password_sent_at < 1.hour.ago
  end

  def clear_reset_password_token
    update!(reset_password_token: nil, reset_password_sent_at: nil)
  end
end
