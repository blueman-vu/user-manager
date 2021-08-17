# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, length: { minimum: 5, maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 7 }, on: :create

  validates_inclusion_of :role, in: %w[admin user]
  has_many :posts, dependent: :destroy

  scope :list_user, lambda { |role, search|
    condition = role == 'admin' ? {} : { is_block: false, role: 'user' }
    where(condition)
    .where('username LIKE ? OR email LIKE ?', "%#{search}%", "%#{search}%")
    .order(created_at: :asc)
  }
  
  scope :top_like, lambda {
    where(role: 'user', is_block: false)
    .sort_by {|user| user.posts.sum(:like_count)}.reverse
  }
end
