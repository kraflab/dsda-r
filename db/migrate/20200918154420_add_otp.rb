class AddOtp < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :otp, :string, default: nil
    add_column :admins, :last_otp_at, :integer, default: 0
  end
end
