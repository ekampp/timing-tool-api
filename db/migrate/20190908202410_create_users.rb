# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension :pgcrypto

    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :users, :email
  end
end
