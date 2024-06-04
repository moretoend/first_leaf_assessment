class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, length: { maximum: 200 }, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :full_name, length: { maximum: 200 }
  validates :password, presence: true, length: { maximum: 60 }
  validates :key, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :account_key, length: { maximum: 100 }, uniqueness: true
  validates :metadata, length: { maximum: 2000 }
end
