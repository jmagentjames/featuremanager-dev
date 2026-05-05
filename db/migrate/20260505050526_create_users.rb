class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :email
  end
end
