RSpec.shared_context 'invalid params' do |invalid_params|
  it 'renders status 422' do
    expect(response).to have_http_status(422)
  end

  it 'renders a message with error' do
    expect(json_response).to have_key('errors')
    expect(json_response['errors']).to eq ["Unpermitted parameters were sent: #{invalid_params.join(', ')}"]
  end
end
