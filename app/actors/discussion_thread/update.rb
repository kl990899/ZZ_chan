class DiscussionThread::Update < Actor
  input :discussion_thread
  input :params

  output :discussion_thread

  def call
    self.discussion_thread = discussion_thread

    if discussion_thread.update(discussion_thread_params)
      handle_file_upload if file_present?
      return
    end

    fail!(error: discussion_thread.errors.full_messages.join(', '))
  end

  private

  def discussion_thread_params
    params.require(:discussion_thread).permit(:title, :name, :content, :file)
  end

  def file_present?
    params[:discussion_thread][:file].present?
  end

  def handle_file_upload
    uploaded_file = params[:discussion_thread][:file]
    content_type = uploaded_file.content_type

    if image_content_type?(content_type)
      discussion_thread.posts.first&.image&.attach(uploaded_file)
    elsif video_content_type?(content_type)
      discussion_thread.posts.first&.video&.attach(uploaded_file)
    end
  end

  def image_content_type?(content_type)
    content_type.in?(['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'image/webp'])
  end

  def video_content_type?(content_type)
    content_type.in?(['video/mp4', 'video/webm'])
  end
end
