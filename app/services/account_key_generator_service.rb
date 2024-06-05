class AccountKeyGeneratorService
  def initialize(account_key_gateway)
    @account_key_gateway = account_key_gateway
  end
  
  def call(key)
    user = User.find_by!(key: key)
    account_key = @account_key_gateway.call(user.email, user.key)
    user.update!(account_key: account_key)
  end
end
