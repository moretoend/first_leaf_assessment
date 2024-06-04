require 'rails_helper'

describe 'POST /api/users' do
  let(:headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

  context 'with valid params' do
    let(:user_params) { attributes_for(:user).slice(:email, :password, :phone_number, :full_name, :metadata) }

    it 'returns status 201' do
      post '/api/users', headers: headers, params: user_params.to_json
      expect(response.status).to eq(201)
    end

    it 'creates a new user' do
      expect do
        post '/api/users', headers: headers, params: user_params.to_json
      end.to change(User, :count).by(1)
    end

    it 'returns the created user' do
      post '/api/users', headers: headers, params: user_params.to_json
      expected_response = user_params.slice(*%i[email phone_number full_name key metadata]).stringify_keys.merge('account_key' => nil)
      expect(json_response).to include(
        'email' => user_params[:email], 'phone_number' => user_params[:phone_number], 'full_name' => user_params[:full_name],
        'metadata' => user_params[:metadata], 'account_key' => nil, 'key' => anything
      )
    end
  end

  context 'with invalid params' do
    let(:user_params) { attributes_for(:user, email: nil).slice(:email, :password, :phone_number, :full_name, :metadata) }

    it 'returns status 422' do
      post '/api/users', headers: headers, params: user_params.to_json
      expect(response.status).to eq(422)
    end

    it 'does not create a new user' do
      expect do
        post '/api/users', headers: headers, params: user_params.to_json
      end.not_to change(User, :count)
    end

    it 'returns an error message' do
      post '/api/users', headers: headers, params: user_params.to_json
      expect(json_response).to eq({ 'errors' => ['Email is missing']})
    end
  end

  it_behaves_like 'internal server error' do
    before do
      post '/api/users', headers: headers, params: { invalid_param: 'senior web', invalid_param2: 'Some name' }
    end
  end
end
