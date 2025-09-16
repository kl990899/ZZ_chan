class Post::Update < Actor
  input :post
  input :params

  output :post

  def call
    self.post = post

    return if post.update(post_params)

    fail!(error: post.errors.full_messages.join(', '))
  end

  private

  def post_params
    params.permit(:discussion_thread_id, :content, :image, :video, :name)
  end
end
