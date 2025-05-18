class AddFieldsToDiscussionThreads < ActiveRecord::Migration[7.2]
  def change
    add_column :discussion_threads, :name, :string
    add_column :discussion_threads, :ip_address, :string
    add_column :discussion_threads, :hash_ip, :string
  end
end
