class DiscussionThread::Find < Actor
  input :id

  output :discussion_thread

  def call
    self.discussion_thread = DiscussionThread.find_by(id: id)

    return if discussion_thread

    fail!(error: '找不到討論串')
  end
end
