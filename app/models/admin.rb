class Admin < ApplicationRecord
  validates :fail_count, numericality: { greater_than_or_equal_to: 0 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :password, length: { minimum: 12 }, allow_blank: true
  has_secure_password

  # Returns the hash digest of the given string.
  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
