class SpamDetectionService
  # 廣告/垃圾訊息檢測服務
  # 廣告關鍵字列表（不區分大小寫）
  SPAM_KEYWORDS = [
    # SEO 和流量相關
    'seo', 'traffic', 'visits', 'visitors', 'website traffic',
    'boost your website', 'increase traffic', 'organic traffic',
    # 服務提供商
    'monkeydigital', 'monkey digital', 'digital-x-press',
    # 聯絡方式
    'whatsapp', 'whats app', 'phone/whatsapp', 'phone/whats app',
    'reach out', 'connect with', 'contact us',
    # 價格和推銷
    /\$\d+/, # $10, $100 等
    'per 10,000', 'per 10k', 'for just \$', 'only \$',
    # 常見廣告用語
    'best regards', 'looking forward', 'ready to scale',
    'check out', 'view the plan', 'see the details',
    # URL 模式
    'monkeydigital.co', 'digital-x-press.com', 'wa.link'
  ].freeze

  # 電話號碼模式
  PHONE_PATTERNS = [
    /\+\d{1,3}\s*\(?\d{3}\)?\s*-?\d{3}\s*-?\d{4}/, # +1 (775) 314-7914
    /phone.*whatsapp/i,
    /whatsapp.*phone/i
  ].freeze

  # 廣告 URL 模式
  SPAM_URL_PATTERNS = [
    /monkeydigital\.co/i,
    /digital-x-press\.com/i,
    /wa\.link/i,
    /whatsapp.*monkeydigital/i,
    /whatsapp.*digital-x-press/i
  ].freeze

  # 檢測文字是否為廣告
  def self.spam?(text)
    return false if text.blank?

    keyword_matches = count_keyword_matches(text)
    phone_matches = matches_phone_pattern?(text)
    url_matches = matches_url_pattern?(text)

    keyword_matches >= 3 || phone_matches || url_matches
  end

  # 檢測討論串是否為廣告
  def self.spam_thread?(thread)
    return false unless thread

    return true if spam?(thread.title)
    return true if thread.respond_to?(:name) && spam?(thread.name)

    first_post = thread.posts&.first
    return false unless first_post

    spam?(first_post.content)
  end

  # 檢測貼文是否為廣告
  def self.spam_post?(post)
    return false unless post

    return true if spam?(post.content)
    return true if post.respond_to?(:name) && spam?(post.name)

    false
  end

  # 獲取所有可能是廣告的討論串
  # 注意：為了準確檢測，需要載入所有討論串進行檢查
  def self.find_spam_threads
    DiscussionThread.includes(:posts).all.select { |thread| spam_thread?(thread) }
  end

  # 獲取所有可能是廣告的貼文
  # 注意：為了準確檢測，需要載入所有貼文進行檢查
  def self.find_spam_posts
    Post.includes(:discussion_thread).all.select { |post| spam_post?(post) }
  end

  # 計算關鍵字匹配數量
  def self.count_keyword_matches(text)
    text_lower = text.downcase
    SPAM_KEYWORDS.count do |keyword|
      if keyword.is_a?(Regexp)
        text_lower.match?(keyword)
      else
        text_lower.include?(keyword.downcase)
      end
    end
  end

  # 檢查是否匹配電話號碼模式
  def self.matches_phone_pattern?(text)
    PHONE_PATTERNS.any? { |pattern| text.match?(pattern) }
  end

  # 檢查是否匹配 URL 模式
  def self.matches_url_pattern?(text)
    SPAM_URL_PATTERNS.any? { |pattern| text.match?(pattern) }
  end
end
