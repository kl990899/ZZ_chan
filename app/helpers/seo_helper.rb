module SeoHelper # rubocop:disable Metrics/ModuleLength
  def meta_title(page_title = nil)
    base_title = 'zz-chan - 討論板'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  def meta_description(description = nil)
    description.presence || 'zz-chan (zz-chan.org) 是一個現代化的討論板平台，支援圖片、影片上傳和 YouTube 嵌入，提供優質的討論體驗。'
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
      "#{first_post.content.truncate(150)} - 在 zz-chan 討論板參與討論"
    else
      '查看這個討論串的內容，在 zz-chan 討論板參與討論'
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
      name: 'zz-chan',
      alternateName: ['zz-chan.org', 'zz-chan 討論板'],
      description: website_description,
      url: root_url,
      inLanguage: 'zh-TW',
      isAccessibleForFree: true,
      audience: website_audience,
      publisher: website_publisher,
      potentialAction: website_search_action,
      mainEntity: website_main_entity
    }.to_json.html_safe
  end

  def website_description
    'zz-chan (zz-chan.org) 是一個現代化的討論板平台，支援圖片、影片上傳和 YouTube 嵌入，提供優質的討論體驗'
  end

  def website_audience
    {
      '@type': 'Audience',
      audienceType: '討論板用戶'
    }
  end

  def website_publisher
    {
      '@type': 'Organization',
      name: 'zz-chan',
      alternateName: 'zz-chan.org',
      url: root_url,
      logo: {
        '@type': 'ImageObject',
        url: "#{root_url}icon.png"
      }
    }
  end

  def website_search_action
    {
      '@type': 'SearchAction',
      target: {
        '@type': 'EntryPoint',
        urlTemplate: "#{root_url}discussion_threads?search={search_term_string}"
      },
      'query-input': 'required name=search_term_string'
    }
  end

  def website_main_entity
    {
      '@type': 'DiscussionForum',
      name: 'zz-chan 討論板',
      alternateName: 'zz-chan.org 討論板',
      description: '一個現代化的討論板平台，支援圖片、影片上傳和 YouTube 嵌入',
      url: discussion_threads_url,
      inLanguage: 'zh-TW'
    }
  end

  def structured_data_discussion_thread(thread)
    {
      '@context': 'https://schema.org',
      '@type': 'DiscussionForumPosting',
      headline: thread.title.presence || '無題',
      description: thread_description(thread),
      url: discussion_thread_url(thread),
      dateCreated: thread.created_at.iso8601,
      dateModified: thread.updated_at.iso8601,
      inLanguage: 'zh-TW',
      isPartOf: discussion_forum_info,
      author: thread_author(thread),
      interactionStatistic: thread_interaction_stats(thread),
      about: thread_about(thread)
    }.to_json.html_safe
  end

  def thread_description(thread)
    thread.posts.first&.content&.truncate(200) || '討論串內容'
  end

  def discussion_forum_info
    {
      '@type': 'DiscussionForum',
      name: 'zz-chan 討論板',
      url: discussion_threads_url
    }
  end

  def thread_author(thread)
    {
      '@type': 'Person',
      name: thread.name.presence || '匿名'
    }
  end

  def thread_interaction_stats(thread)
    {
      '@type': 'InteractionCounter',
      interactionType: 'https://schema.org/CommentAction',
      userInteractionCount: thread.posts.count
    }
  end

  def thread_about(thread)
    {
      '@type': 'Thing',
      name: thread.title.presence || '討論話題'
    }
  end

  def structured_data_organization
    {
      '@context': 'https://schema.org',
      '@type': 'Organization',
      name: 'zz-chan',
      alternateName: ['zz-chan.org', 'zz-chan 討論板'],
      url: root_url,
      logo: {
        '@type': 'ImageObject',
        url: "#{root_url}icon.png"
      },
      description: 'zz-chan (zz-chan.org) 現代化的討論板平台，支援圖片、影片上傳和 YouTube 嵌入',
      foundingDate: '2024',
      founder: {
        '@type': 'Person',
        name: 'Zan Zas'
      },
      sameAs: [
        root_url
      ]
    }.to_json.html_safe
  end

  def structured_data_webpage(page_title, page_description, page_url)
    {
      '@context': 'https://schema.org',
      '@type': 'WebPage',
      name: page_title,
      description: page_description,
      url: page_url,
      inLanguage: 'zh-TW',
      isPartOf: {
        '@type': 'WebSite',
        name: 'zz-chan',
        url: root_url
      },
      publisher: {
        '@type': 'Organization',
        name: 'zz-chan',
        url: root_url
      },
      datePublished: Time.current.iso8601,
      dateModified: Time.current.iso8601
    }.to_json.html_safe
  end
end
