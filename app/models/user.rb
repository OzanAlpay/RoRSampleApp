class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum:50}
  validates :password, presence: true, length: {minimum:6}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum:250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false}
  has_secure_password
  
  def User.digest(string)
    #TODO Understand here well
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
