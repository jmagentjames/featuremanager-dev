class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :email
      t.text :body
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end
