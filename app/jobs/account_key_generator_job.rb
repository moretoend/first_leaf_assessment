class AccountKeyGeneratorJob < ActiveJob::Base
  retry_on RequestError

  def perform(key)
    gateway = AccountKeyGateway.new
    account_key_generator = AccountKeyGeneratorService.new(gateway)
    account_key_generator.call(key)
  end
end
