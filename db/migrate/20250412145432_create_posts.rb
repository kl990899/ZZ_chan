class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :discussion_thread, null: false, foreign_key: true
      t.text :content
      t.string :image

      t.timestamps
    end
  end
end
