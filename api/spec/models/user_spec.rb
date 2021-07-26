# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it {
    should validate_length_of(:username)
      .is_at_least(5)
      .is_at_most(50)
  }
  it { should validate_presence_of(:password) }
  it {
    should_not validate_length_of(:password)
      .is_at_least(6)
  }

  it { should validate_inclusion_of(:role).in_array(%w[user admin]) }
end
