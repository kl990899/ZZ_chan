class SitemapController < ApplicationController
  def index
    @discussion_threads = DiscussionThread.order(updated_at: :desc).limit(1000)
    respond_to(&:xml)
  end
end
