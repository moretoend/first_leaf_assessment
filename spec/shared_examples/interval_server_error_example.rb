RSpec.shared_context 'internal server error' do |invalid_params|
  it 'renders status 500' do
    expect(response).to have_http_status(500)
  end

  it 'renders a message with error' do
    expect(json_response).to have_key('errors')
    expect(json_response['errors']).to eq ["Something bad happened on our side"]
  end
end
