class DiscussionThread::Destroy < Actor
  input :discussion_thread

  output :success

  def call
    discussion_thread.destroy!
    self.success = true
  rescue StandardError => e
    fail!(error: e.message)
  end
end
