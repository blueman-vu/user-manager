# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :published_date, :alias_name, :email

  def email
    object.user.email
  end
end
