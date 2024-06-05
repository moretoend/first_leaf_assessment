require 'httparty'

class AccountKeyGateway
  class KeyNotGenerated < StandardError; end

  PATH = '/v1/account'
  private_constant :PATH

  def call(email, key)
    response = HTTParty.post("#{ENV.fetch('ACCOUNT_KEY_BASE_URL')}#{PATH}",
                             headers: { 'Content-Type' => 'application/json' },
                             body: { email: email, key: key }.to_json)
    raise KeyNotGenerated, "Account were not generated. Response code: #{response.code}" if response.code >= 400

    response.parsed_response['account_key']
  rescue HTTParty::Error => e
    raise KeyNotGenerated, "Account were due to request issues: #{e.message}"
  end
end
