class AddLicenseKeyToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :license_key, :string
  end
end
