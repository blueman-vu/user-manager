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
  
  describe 'list_user' do
    let!(:user1) {create(:user)}
    let!(:user2) {create(:user, email: 'alice@gmail.com')}
    let!(:user3) {create(:user, username: 'alice july')}
    let!(:user4) {create(:user, role: 'admin')}
    let!(:user5) {create(:user, username: 'alice lucy', is_block: true)}
    let!(:user6) {create(:user, is_block: true)}

    context 'filter with admin' do
      it 'search all' do
        expect(User.list_user('admin', '').count).to eq(6)
      end

      it 'search by alice' do 
        expect(User.list_user('admin', 'alice').count).to eq(3)
      end
    end

    context 'filter with user' do
      it 'user search all' do
        expect(User.list_user('user', '').count).to eq(3)
      end

      it 'search alice' do
        expect(User.list_user('user', 'alice').count).to eq(2)
      end
    end
  end
end
