class Post::Find < Actor
  input :id

  output :post

  def call
    self.post = Post.find_by(id: id)

    return if post

    fail!(error: '找不到貼文')
  end
end
