class UserKeyGenerator
  KEY_SIZE = 100
  private_constant :KEY_SIZE

  def self.call
    loop do
      key = SecureRandom.alphanumeric(KEY_SIZE)
      break key if User.find_by(key: key).nil?
    end
  end
end
