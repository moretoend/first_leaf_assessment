require 'rails_helper'

describe AccountKeyGateway do
  let!(:user) { create(:user) }

  it 'returns account key along with user email' do
    account_key = SecureRandom.hex
    httparty_response = double(code: 200, parsed_response: { 'email' => user.email, 'account_key' => account_key })
    allow(HTTParty).to receive(:post).and_return(httparty_response)
    
    result = subject.call(user.email, user.key)
    expect(result).to eq(account_key)
  end

  it 'call :post with right url and params' do
    url = 'http://test.com'
    ENV['ACCOUNT_KEY_BASE_URL'] = url
    account_key = SecureRandom.hex
    httparty_response = double(code: 200, parsed_response: { 'email' => user.email, 'account_key' => account_key })
    expect(HTTParty).to receive(:post).with(url + "/v1/account",
                                            headers: { 'Content-Type' => 'application/json' },
                                            body: { email: user.email, key: user.key }.to_json)
                                      .and_return(httparty_response)
    subject.call(user.email, user.key)
  end

  it 'raises an error when request fails' do
    httparty_response = double(code: 422)
    allow(HTTParty).to receive(:post).and_return(httparty_response)
    
    expect { subject.call(user.email, user.key) }.to raise_error(RequestError)
  end

  it 'raises an error when some HTTParty error is raised' do
    allow(HTTParty).to receive(:post).and_raise(HTTParty::UnsupportedURIScheme)
    expect { subject.call(user.email, user.key) }.to raise_error(RequestError)
  end
end
