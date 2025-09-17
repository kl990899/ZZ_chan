module SeoHelper # rubocop:disable Metrics/ModuleLength
  def meta_title(page_title = nil)
    base_title = 'Zz Chan - 討論板'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  def meta_description(description = nil)
    description.presence || 'Zz Chan 是一個現代化的討論板平台，支援圖片、影片上傳和 YouTube 嵌入，提供優質的討論體驗。'
  end

  def meta_keywords(keywords = nil)
    keywords.presence || '討論板,論壇,社群,討論,圖片分享,影片分享,YouTube,匿名討論'
  end

  def og_image_url(image_url = nil)
    if image_url.present?
      # 如果是完整的 URL，直接返回
      if image_url.start_with?('http')
        image_url
      else
        "#{request.base_url}#{image_url}"
      end
    else
      "#{request.base_url}/og-default-1200x630.html"
    end
  end

  def canonical_url(url = nil)
    url.presence || request.original_url
  end

  def discussion_thread_og_data(thread)
    first_post = thread.posts.order(:created_at).first
    image_url = determine_thread_og_image(first_post)

    {
      title: thread.title.presence || '無題',
      description: generate_thread_description(first_post),
      type: 'article',
      url: discussion_thread_url(thread),
      image: image_url || og_image_url
    }
  end

  def determine_thread_og_image(first_post)
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

  def generate_thread_description(first_post)
    if first_post&.content&.present?
      "#{first_post.content.truncate(150)} - 在 Zz Chan 討論板參與討論"
    else
      '查看這個討論串的內容，在 Zz Chan 討論板參與討論'
    end
  end

  def post_og_data(post)
    image_url = post.image.attached? ? image_url_from_attachment(post.image) : nil

    {
      title: "#{post.name.presence || '無名'} 的貼文",
      description: post.content&.truncate(160) || '查看這則貼文',
      type: 'article',
      url: discussion_thread_url(post.discussion_thread),
      image: image_url || og_image_url
    }
  end

  def structured_data_breadcrumb(items)
    {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      itemListElement: items.map.with_index do |item, index|
        {
          '@type': 'ListItem',
          position: index + 1,
          name: item[:name],
          item: item[:url]
        }
      end
    }.to_json.html_safe
  end

  def structured_data_website
    {
      '@context': 'https://schema.org',
      '@type': 'WebSite',
      name: 'Zz Chan',
      description: '現代化的討論板平台',
      url: root_url,
      potentialAction: {
        '@type': 'SearchAction',
        target: {
          '@type': 'EntryPoint',
          urlTemplate: "#{root_url}discussion_threads?search={search_term_string}"
        },
        'query-input': 'required name=search_term_string'
      }
    }.to_json.html_safe
  end

  def structured_data_discussion_thread(thread)
    {
      '@context': 'https://schema.org',
      '@type': 'DiscussionForumPosting',
      headline: thread.title.presence || '無題',
      description: thread.posts.first&.content&.truncate(200) || '討論串內容',
      url: discussion_thread_url(thread),
      dateCreated: thread.created_at.iso8601,
      dateModified: thread.updated_at.iso8601,
      author: {
        '@type': 'Person',
        name: thread.name.presence || '匿名'
      },
      interactionStatistic: {
        '@type': 'InteractionCounter',
        interactionType: 'https://schema.org/CommentAction',
        userInteractionCount: thread.posts.count
      }
    }.to_json.html_safe
  end
end
