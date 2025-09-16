class Post::Destroy < Actor
  input :post

  output :success

  def call
    post.destroy!
    self.success = true
  rescue StandardError => e
    fail!(error: e.message)
  end
end
