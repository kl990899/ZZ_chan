class AddNameAndIpToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :name, :string
    add_column :posts, :ip_address, :string
    add_column :posts, :hashed_ip, :string
  end
end
