class Admin < ApplicationRecord
  LOGIN_FAIL_LIMIT = 5

  validates :fail_count, numericality: { greater_than_or_equal_to: 0 }
  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: true,
                       format: { with: VALID_USERNAME_REGEX }
  validates :password, length: { minimum: 12 }, allow_blank: true
  has_secure_password

  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def account_locked?
    fail_count >= LOGIN_FAIL_LIMIT
  end

  def fail_login!
    update(fail_count: fail_count + 1)
  end

  def try_authenticate(password)
    return nil if account_locked?
    return self if authenticate(password)
    fail_login!
    nil
  end
end
