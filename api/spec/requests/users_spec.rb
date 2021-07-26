require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
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
        expect(json['message']).to eq("Validation failed: Password is too short (minimum is 7 characters)")
      end

      it 'username is shot' do
        post '/signup', params: { username: 'user', email: 'user1@gmail.com', password: 'password' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq("Validation failed: Username is too short (minimum is 5 characters)")
      end

      it 'username is long ' do
        post '/signup', params: { username: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', email: 'user1@gmail.com', password: 'pass' }
        expect(response).to have_http_status(422)
        expect(json['message']).to eq("Validation failed: Username is too long (maximum is 50 characters), Password is too short (minimum is 7 characters)")
      end
    end
  end
end