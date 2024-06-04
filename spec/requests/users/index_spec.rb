require 'rails_helper'

describe 'GET /api/users' do
  let!(:users) { create_list(:user, 10) }

  context 'without any search params' do
    it 'returns status 200' do
      get '/api/users', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(200)
    end

    it 'returns all users ordered by most recently created without search params' do
      get '/api/users', headers: { 'Accept' => 'application/json' }
      expect(json_response).to have_key('users')

      expected_users_response = users.sort { |a, b| b.created_at <=> a.created_at}
                                    .map { |user| user.slice(:email, :phone_number, :full_name, :key, :account_key, :metadata) }
      expect(json_response['users']).to eq expected_users_response
    end
  end

  context 'with search params' do
    context 'when :email is sent' do
      let!(:users_to_filter) { [create(:user, email: 'test1@test.com'), create(:user, email: 'test2@test.com')] }

      it 'returns status 200' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { email: '@test' }
        expect(response).to have_http_status(200)
      end

      it 'returns users filtered by email' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { email: '@test' }
        expect(json_response).to have_key('users')

        expected_users_response = users_to_filter.sort { |a, b| b.created_at <=> a.created_at}
                                                 .map { |user| user.slice(:email, :phone_number, :full_name, :key, :account_key, :metadata) }
        expect(json_response['users']).to eq expected_users_response
      end
    end

    context 'when :full_name is sent' do
      let!(:users_to_filter) { [create(:user, full_name: 'Some name 1'), create(:user, full_name: 'Some name 2')] }

      it 'returns status 200' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { full_name: 'Some' }
        expect(response).to have_http_status(200)
      end

      it 'returns users filtered by full name' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { full_name: 'Some' }
        expect(json_response).to have_key('users')
  
        expected_users_response = users_to_filter.sort { |a, b| b.created_at <=> a.created_at}
                                                 .map { |user| user.slice(:email, :phone_number, :full_name, :key, :account_key, :metadata) }
        expect(json_response['users']).to eq expected_users_response
      end
    end

    context 'when :metadata is sent' do
      let!(:users_to_filter) { [create(:user, metadata: 'senior web developer'), create(:user, metadata: 'senior web developer')] }

      it 'returns status 200' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { metadata: 'senior web' }
        expect(response).to have_http_status(200)
      end

      it 'returns users filtered by metadata' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { metadata: 'senior web' }
        expect(json_response).to have_key('users')
  
        expected_users_response = users_to_filter.sort { |a, b| b.created_at <=> a.created_at}
                                                 .map { |user| user.slice(:email, :phone_number, :full_name, :key, :account_key, :metadata) }
        expect(json_response['users']).to eq expected_users_response
      end
    end

    context 'when all filters are sent' do
      let!(:users_to_filter) do
        [
          create(:user, email: 'test1@test.com', full_name: 'Some name 1', metadata: 'senior web developer'),
          create(:user, email: 'test2@test.com', full_name: 'Some name 2', metadata: 'senior web devops')
        ]
      end

      it 'returns status 200' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { email: '@test', full_name: 'Some', metadata: 'senior web' }
        expect(response).to have_http_status(200)
      end

      it 'returns users filtered by all params' do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { email: '@test', full_name: 'Some', metadata: 'senior web' }
        expect(json_response).to have_key('users')
  
        expected_users_response = users_to_filter.sort { |a, b| b.created_at <=> a.created_at}
                                                 .map { |user| user.slice(:email, :phone_number, :full_name, :key, :account_key, :metadata) }
        expect(json_response['users']).to eq expected_users_response
      end
    end

    it_behaves_like 'invalid params', [:invalid_param, :invalid_param2] do
      before do
        get '/api/users', headers: { 'Accept' => 'application/json' }, params: { invalid_param: 'senior web', invalid_param2: 'Some name' }
      end
    end
  end
end
