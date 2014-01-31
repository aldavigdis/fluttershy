class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.string :password
      t.string :password_hash
      t.string :recovery_code
      t.datetime :recovery_expires
      t.integer :access
      t.text :comments
      t.boolean :enabled

      t.timestamps
    end
  end
end
