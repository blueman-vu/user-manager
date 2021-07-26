class User < ApplicationRecord
  has_secure_password
  validates :username, length: { minimum: 5, maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 7 }

  validates_inclusion_of :role, in: %w[admin user]
end