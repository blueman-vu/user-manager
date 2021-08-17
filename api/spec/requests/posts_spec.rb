require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let!(:posts) { create_list(:post, 10, user_id: user.id) }
  let!(:target_post) { create(:post, user_id: user.id, title: 'Phước Vũ')}
  let(:alias_name) { posts.first.alias_name }
  # authorize request
  let(:headers) { valid_headers }
  let(:invalid_headers) { { 'Authorization' => nil } }
  let(:user_1_headers) {
    {
      'Authorization' => token_generator(user1.id),
      'Content-Type' => 'application/json'
    }
  }

  let(:admin_user) { create(:user, role: 'admin') }
  let(:admin_headers) {
    {
      'Authorization' => token_generator(admin_user.id),
      'Content-Type' => 'application/json'
    }
  }

  # Test suite for GET /posts
  describe 'GET /posts' do
    context 'get all posts' do
      # make HTTP get request before each example
      before { get '/posts', params: { page: 1 }, headers: headers }

      it 'returns posts' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json['posts'].size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'get posts by search' do
      before { get "/posts?search=phuoc vu", params: { page: 1 }, headers: admin_headers }
      it 'success' do
        expect(response).to have_http_status(200)
        expect(json['posts'].size).to eq(1)
      end
    end
  end

  # Test suite for GET /posts/:alias_name
  describe 'GET /posts/:alias_name' do
    before { get "/posts/#{alias_name}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['alias_name']).to eq(alias_name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:alias_name) { 'test_alias' }

      it 'returns status code 404' do
        expect(response).to have_http_status(422)
      end

      it 'returns a not found message' do
        expect(json['message'])
        .to eq("Record not found")
      end
    end
  end

  # Test suite for POST /posts
  describe 'POST /posts' do
    # valid payload
    let(:valid_attributes) { { title: 'Đây là title', content: 'this is content', is_published: true } }

    context 'when the request is valid' do
      before { post '/posts', params: valid_attributes.to_json, headers: headers }

      it 'creates a todo' do
        expect(json['title']).to eq('Đây là title')
        expect(json['alias_name']).to eq('day-la-title')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/posts', params: { content: 'Foobar' }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
        .to eq("Validation failed: Title can't be blank")
      end
    end

    context 'when the request header is invalid' do
      before { post '/posts', params: { title: 'title', content: 'Foobar' }.to_json, headers: invalid_headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message'])
        .to eq("Missing token")
      end
    end
  end

  # Test suite for PUT /posts/:alias_name
  describe 'PUT /posts/:alias_name' do

    describe 'user is creater' do 
      let(:valid_attributes) { { is_published: true } }

      context 'when the record exists' do
        before { put "/posts/#{alias_name}", params: valid_attributes.to_json, headers: headers }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    describe 'user is admin' do 
      let(:valid_attributes) { { is_published: true } }

      context 'when the record exists' do
        before { put "/posts/#{alias_name}", params: valid_attributes.to_json, headers: admin_headers }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    describe 'user is another user' do 
      let(:valid_attributes) { { is_published: true } }

      context 'when the record exists' do
        before { put "/posts/#{alias_name}", params: valid_attributes.to_json, headers: user_1_headers }

        it 'updates the record' do
          expect(json['message'])
          .to eq('You do not have permission to do that')
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(422)
        end
      end
    end

  end

  # Test suite for DELETE /posts/:alias_name
  describe 'DELETE /posts/:alias_name' do
    describe 'user is creater' do 
      before { delete "/posts/#{alias_name}",  headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    describe 'user is admin' do 
      before { delete "/posts/#{alias_name}",  headers: admin_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    describe 'user is another user' do 
      before { delete "/posts/#{alias_name}",  headers: user_1_headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
