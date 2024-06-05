class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 200, null: false
      t.string :phone_number, limit: 20, null: false
      t.string :full_name, limit: 200
      t.string :password_digest, limit: 72, null: false
      t.string :key, limit: 100, null: false
      t.string :account_key, limit: 100
      t.string :metadata, limit: 2000

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :key, unique: true
    add_index :users, :account_key, unique: true
  end
end
