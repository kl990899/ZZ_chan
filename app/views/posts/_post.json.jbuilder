json.extract! post, :id, :discussion_thread_id, :content, :image, :created_at, :updated_at
json.url post_url(post, format: :json)
