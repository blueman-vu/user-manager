# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role
  attribute :is_block, if: :condition?

  def condition?
    @instance_options[:role] == 'admin'
  end
end
