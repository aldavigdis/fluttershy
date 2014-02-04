class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.references :user, index: true
      t.text :useragent
      t.binary :ip_addr
      t.boolean :success

      t.timestamps
    end
  end
end
