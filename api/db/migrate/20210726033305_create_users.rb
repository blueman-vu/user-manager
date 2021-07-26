# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :role, default: 'user'
      t.boolean :is_block, default: false

      t.timestamps
    end
  end
end
