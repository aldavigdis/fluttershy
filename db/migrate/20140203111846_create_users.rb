class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.text :password_hash
      t.string :password_seed
      t.string :recovery_code
      t.datetime :recovery_expires
      t.integer :access
      t.text :comments
      t.boolean :enabled
      t.text :remember_hash
      t.references :company, index: true

      t.timestamps
    end
  end
end
