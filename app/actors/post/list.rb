class Post::List < Actor
  input :discussion_thread_id
  input :params, default: nil

  output :posts

  def call
    self.posts = Post.where(discussion_thread_id: discussion_thread_id)
                     .order(created_at: :asc)
                     .page(params&.dig(:page))
                     .per(20)
  end
end
