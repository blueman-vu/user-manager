# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, length: { minimum: 5, maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 7 }

  validates_inclusion_of :role, in: %w[admin user]

  scope :list_user, lambda { |role|
    condition = role == 'admin' ? {} : { is_block: false, role: 'user' }
    where(condition).order(created_at: :asc)
  }
end
