class DiscussionThread::List < Actor
  input :params, default: nil

  output :discussion_threads

  def call
    self.discussion_threads = DiscussionThread.all
                                              .order(updated_at: :desc)
                                              .page(params&.dig(:page))
                                              .per(12)
  end
end
