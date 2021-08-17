# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_date, :alias_name, :email, :content, :is_published, :like_count

  def email
    object.user.email
  end

  def like_count
    object.like_count.to_i
  end
end
