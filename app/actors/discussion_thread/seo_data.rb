require 'service_actor'

class DiscussionThread::SeoData < Actor
  input :discussion_thread

  output :title
  output :description
  output :keywords
  output :og_data
  output :structured_data
  output :og_image_type

  def call
    self.title = generate_title
    self.description = generate_description
    self.keywords = generate_keywords
    self.og_data = generate_og_data
    self.structured_data = generate_structured_data
    self.og_image_type = generate_og_image_type
  end

  private

  def generate_title
    base_title = discussion_thread.title.presence || '無題'
    "#{base_title} | Zz Chan 討論板"
  end

  def generate_description
    first_post = discussion_thread.posts.order(:created_at).first
    if first_post&.content.present?
      "#{first_post.content.truncate(150)} - 在 Zz Chan 討論板參與討論"
    else
      '查看這個討論串的內容，在 Zz Chan 討論板參與討論'
    end
  end

  def generate_keywords
    keywords = ['討論板', '論壇', '社群討論']
    keywords << '圖片分享' if images?
    keywords << '影片分享' if videos?
    keywords << 'YouTube' if youtube_links?
    keywords.join(', ')
  end

  def generate_og_data
    first_post = discussion_thread.posts.order(:created_at).first
    image_url = determine_og_image(first_post)

    {
      title: discussion_thread.title.presence || '無題',
      description: generate_og_description(first_post),
      type: 'article',
      url: Rails.application.routes.url_helpers.discussion_thread_url(discussion_thread, only_path: true),
      image: image_url
    }
  end

  def determine_og_image(first_post)
    return image_url_from_attachment(first_post.image) if first_post&.image&.attached?
    return youtube_thumbnail_url(first_post) if first_post&.youtube_links?(nil)
    return image_url_from_attachment(first_post.video) if first_post&.video&.attached?

    nil
  end

  def image_url_from_attachment(attachment)
    return nil unless attachment&.attached?

    set_active_storage_options
    generate_attachment_url(attachment)
  rescue StandardError
    attachment.url
  end

  def youtube_thumbnail_url(first_post)
    video_ids = first_post.youtube_video_ids(nil)
    return nil unless video_ids.any?

    "https://img.youtube.com/vi/#{video_ids.first}/maxresdefault.jpg"
  end

  def generate_attachment_url(attachment)
    signed_id = attachment.signed_id
    filename = attachment.filename.to_s
    "https://zz-chan.org/rails/active_storage/blobs/#{signed_id}/#{filename}"
  end

  def set_active_storage_options
    ActiveStorage::Current.url_options = {
      host: 'zz-chan.org',
      protocol: 'https'
    }
  end

  def generate_og_description(first_post)
    if first_post&.content&.present?
      "#{first_post.content.truncate(150)} - 在 Zz Chan 討論板參與討論"
    else
      '查看這個討論串的內容，在 Zz Chan 討論板參與討論'
    end
  end

  def generate_structured_data
    {
      '@context': 'https://schema.org',
      '@type': 'DiscussionForumPosting',
      headline: discussion_thread.title.presence || '無題',
      description: first_post_content,
      url: discussion_thread_url,
      dateCreated: discussion_thread.created_at.iso8601,
      dateModified: discussion_thread.updated_at.iso8601,
      author: structured_data_author,
      interactionStatistic: structured_data_interaction
    }
  end

  def discussion_thread_url
    Rails.application.routes.url_helpers.discussion_thread_url(discussion_thread, only_path: true)
  end

  def structured_data_author
    {
      '@type': 'Person',
      name: discussion_thread.name.presence || '匿名'
    }
  end

  def structured_data_interaction
    {
      '@type': 'InteractionCounter',
      interactionType: 'https://schema.org/CommentAction',
      userInteractionCount: discussion_thread.posts.count
    }
  end

  def first_post_content
    first_post = discussion_thread.posts.order(:created_at).first
    first_post&.content&.truncate(200) || '討論串內容'
  end

  def images?
    discussion_thread.posts.joins(:image_attachment).exists?
  end

  def videos?
    discussion_thread.posts.joins(:video_attachment).exists?
  end

  def youtube_links?
    discussion_thread.posts.any? { |post| post.youtube_links?(nil) }
  end

  def generate_og_image_type
    first_post = discussion_thread.posts.order(:created_at).first

    if first_post&.image&.attached?
      first_post.image.content_type
    elsif first_post&.youtube_links?(nil)
      'image/jpeg' # YouTube 縮圖是 JPEG
    elsif first_post&.video&.attached?
      first_post.video.content_type
    else
      'image/png' # 預設圖片是 PNG
    end
  end
end
