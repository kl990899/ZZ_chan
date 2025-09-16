class DiscussionThread::Create < Actor
  input :params
  input :request_ip

  output :discussion_thread

  def call
    ActiveRecord::Base.transaction do
      create_discussion_thread
      create_initial_post

      return if discussion_thread.save

      fail!(error: discussion_thread.errors.full_messages.join(', '))
    end
  rescue StandardError => e
    fail!(error: e.message)
  end

  private

  def create_discussion_thread
    thread_name = params[:name].presence || '匿名'
    thread_title = params[:title].presence || '無題'

    self.discussion_thread = DiscussionThread.new(
      name: thread_name,
      title: thread_title
    )
  end

  def create_initial_post
    post = discussion_thread.posts.build(
      name: discussion_thread.name,
      content: params[:content],
      ip_address: request_ip,
      hashed_ip: generate_hashed_ip
    )

    attach_file_if_present(post)
  end

  def generate_hashed_ip
    Digest::SHA256.hexdigest(request_ip)[0, 8]
  end

  def attach_file_if_present(post)
    return unless params[:file].present?

    uploaded_file = params[:file]
    content_type = uploaded_file.content_type

    if image_content_type?(content_type)
      post.image.attach(uploaded_file)
    elsif video_content_type?(content_type)
      post.video.attach(uploaded_file)
    else
      post.errors.add(:file, '不支援的檔案類型，只支援圖片 (JPEG, JPG, PNG, GIF, WebP) 或影片 (MP4, WebM) 格式')
    end
  end

  def image_content_type?(content_type)
    content_type.in?(['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'image/webp'])
  end

  def video_content_type?(content_type)
    content_type.in?(['video/mp4', 'video/webm'])
  end
end
