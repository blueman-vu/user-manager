class Post < ApplicationRecord

  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :alias_name, presence: true
end
