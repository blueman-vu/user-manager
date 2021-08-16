class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :alias_name
      t.text :content
      t.boolean :is_published, default: false
      t.datetime :published_date
      t.references :user, foreign_key: true
      t.integer :like_count
      
      t.timestamps
    end
  end
end
