class User < ApplicationRecord
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :password, length: { minimum: 32 }, allow_blank: true
  has_secure_password
end
