class Message < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body, presence: true, length: { minimum: 10 }

  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
end
