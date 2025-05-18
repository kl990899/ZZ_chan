class Post < ApplicationRecord
  belongs_to :discussion_thread
  has_one_attached :image
end