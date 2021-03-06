# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :role, :total_like
  attribute :is_block, if: :admin?

  def admin?
    @instance_options[:role] == 'admin'
  end

  def total_like
    object.posts.sum(:like_count)
  end
end
