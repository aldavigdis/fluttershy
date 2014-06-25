class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.references :user, index: true
      t.text :useragent
      # Ip addresses are stored in the form of BLOB, as a typical interger
      # value for a IPv6 address can be much larger than the maximum value of
      # even an unsigned BIGINT (18446744073709551615)
      t.binary :ip_addr
      t.boolean :success
      t.timestamps
    end
  end
end
