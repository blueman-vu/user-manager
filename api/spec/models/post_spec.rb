require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
  it {
    should validate_length_of(:title)
      .is_at_most(50)
  }
end
