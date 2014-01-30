class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :kt, limit: 10
      t.text :comments
      t.string :email
      t.string :tel
      t.string :mobile
      t.string :fax
      t.text :contact_name
      t.string :address1
      t.string :address2
      t.string :postcode
      t.string :city
      t.string :shipping_address1
      t.string :shipping_address2
      t.string :shipping_postcode
      t.string :shipping_city
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
