class DiscussionThread::Update < Actor
  input :discussion_thread
  input :params

  output :discussion_thread

  def call
    self.discussion_thread = discussion_thread

    return if discussion_thread.update(discussion_thread_params)

    fail!(error: discussion_thread.errors.full_messages.join(', '))
  end

  private

  def discussion_thread_params
    params.permit(:title, :name, :content, :image, :video)
  end
end
