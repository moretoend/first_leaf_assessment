class User < ApplicationRecord
  has_secure_password

  attr_readonly :key

  validates :email, presence: true, length: { maximum: 200 }, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 60 }
  validates :account_key, length: { maximum: 100 }, uniqueness: true, allow_nil: true
  validates :metadata, length: { maximum: 2000 }

  before_validation :generate_key, on: :create

  def generate_key
    self.key = UserKeyGenerator.call
  end
end
