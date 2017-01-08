class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum:50}
  validates :password, presence: true, length: {minimum:6}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum:250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}
  has_secure_password
end
