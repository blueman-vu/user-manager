# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:block_user) { build(:user, is_block: true) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user)
  end

  # User signup test suite
  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
        expect(json['message'])
          .to eq("Validation failed: Password can't be blank, Username can't be blank, Username is too short (minimum is 5 characters), Email can't be blank, Password can't be blank, Password is too short (minimum is 7 characters)")
      end
    end

    context 'when missing params' do
      it 'missing username' do
        post '/signup', params: { email: 'user1@gmail.com', password: 'password' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq("Validation failed: Username can't be blank, Username is too short (minimum is 5 characters)")
      end

      it 'missing email' do
        post '/signup', params: { username: 'username1', password: 'password' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq("Validation failed: Email can't be blank")
      end

      it 'missing password' do
        post '/signup', params: { email: 'user1@gmail.com', username: 'username1' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq("Validation failed: Password can't be blank, Password can't be blank, Password is too short (minimum is 7 characters)")
      end
    end

    context 'when invalid params' do
      it 'password is short' do
        post '/signup', params: { username: 'username1', email: 'user1@gmail.com', password: 'pass' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq('Validation failed: Password is too short (minimum is 7 characters)')
      end

      it 'username is shot' do
        post '/signup', params: { username: 'user', email: 'user1@gmail.com', password: 'password' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq('Validation failed: Username is too short (minimum is 5 characters)')
      end

      it 'username is long ' do
        post '/signup',
             params: {
               username: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', email: 'user1@gmail.com', password: 'pass'
             }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq('Validation failed: Username is too long (maximum is 50 characters), Password is too short (minimum is 7 characters)')
      end
    end
  end

  describe 'get list users' do
    let!(:user) { create(:user) }
    let!(:admin_user) { create(:user, role: 'admin') }
    let(:admin_header) do
      {
        'Authorization' => token_generator(admin_user.id),
        'Content-Type' => 'application/json'
      }
    end
    let(:user_header) do
      {
        'Authorization' => token_generator(user.id),
        'Content-Type' => 'application/json'
      }
    end
    context 'without page' do
      let!(:block_user) { create(:user, is_block: true) }
      before { get '/users', headers: admin_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json.count).to eq(1)
      end

      before { get '/users', headers: user_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json.count).to eq(1)
      end
    end

    context 'with page' do
      before { get '/users', params: { page: 2 }, headers: admin_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json.count).to eq(0)
      end

      before { get '/users', params: { page: 2 }, headers: user_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json.count).to eq(0)
      end
    end

    context 'block user if signin user is admin' do
      let!(:user2) { create(:user) }
      before { post '/block_user', params: { id: user2.id }.to_json, headers: admin_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json).to eq(true)
      end
    end

    context 'block user if signin user is not admin' do
      let!(:user2) { create(:user) }
      before { post '/block_user', params: { id: user2.id }.to_json, headers: user_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json).to eq(false)
      end
    end

    context 'delete user if signin user is admin' do
      let!(:user2) { create(:user) }
      before { post '/delete', params: { id: user2.id }.to_json, headers: admin_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json).to eq(true)
      end
    end

    context 'delete user if signin user is not admin' do
      let!(:user2) { create(:user) }
      before { post '/delete', params: { id: user2.id }.to_json, headers: user_header }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json).to eq(false)
      end
    end
  end
end
