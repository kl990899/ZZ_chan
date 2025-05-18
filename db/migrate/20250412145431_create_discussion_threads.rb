class CreateDiscussionThreads < ActiveRecord::Migration[7.2]
  def change
    create_table :discussion_threads do |t|
      t.string :title

      t.timestamps
    end
  end
end
