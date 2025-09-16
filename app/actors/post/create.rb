class Post::Create < Actor
  input :params
  input :request_ip

  output :post

  def call
    ActiveRecord::Base.transaction do
      create_post
      attach_file_if_present

      return if post.save

      fail!(error: post.errors.full_messages.join(', '))
    end
  rescue StandardError => e
    fail!(error: e.message)
  end

  private

  def create_post
    discussion_thread = DiscussionThread.find(params[:discussion_thread_id])

    self.post = discussion_thread.posts.new(post_params)
    post.name = '無名' if post.name.blank?
    post.ip_address = request_ip
    post.hashed_ip = generate_hashed_ip
    post.save!
  end

  def post_params
    params.require(:post).permit(:content, :image, :video, :name)
  end

  def generate_hashed_ip
    Digest::SHA256.hexdigest(request_ip)[0..7]
  end

  def attach_file_if_present
    return unless params[:post]&.dig(:file).present?

    uploaded_file = params[:post][:file]
    content_type = uploaded_file.content_type

    if image_content_type?(content_type)
      post.image.attach(uploaded_file)
    elsif video_content_type?(content_type)
      post.video.attach(uploaded_file)
    else
      post.errors.add(:file, '不支援的檔案類型，只支援圖片 (JPEG, PNG, GIF, WebP) 或影片 (MP4, WebM, OGG, MOV) 格式')
    end
  end

  def image_content_type?(content_type)
    content_type.in?(['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'image/webp'])
  end

  def video_content_type?(content_type)
    content_type.in?(['video/mp4', 'video/webm'])
  end
end
