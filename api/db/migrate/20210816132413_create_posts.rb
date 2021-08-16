class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :alias_name
      t.text :content
      t.boolean :is_published, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
