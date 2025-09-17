class SitemapController < ApplicationController
  include SitemapHelper

  def index
    @discussion_threads = DiscussionThread.order(updated_at: :desc).limit(1000)
    respond_to(&:xml)
  end
end
