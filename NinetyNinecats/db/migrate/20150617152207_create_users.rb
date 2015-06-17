class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, null: false
      t.string :password_digest, null: false
      t.text :session_token, null: false

      t.timestamps
    end

    add_index(:users, :session_token, unique: :true)
  end
end
