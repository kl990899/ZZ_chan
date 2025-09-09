module ApplicationHelper
  # 處理 YouTube 連結並轉換為內嵌影片
  def embed_youtube_links(content)
    return content if content.blank?
    
    result = content.dup
    
    # 先處理已存在的 iframe 標籤
    result = process_existing_iframes(result)
    
    # 然後處理 YouTube 連結
    youtube_patterns = [
      # 標準 YouTube 連結
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)/,
      # 短連結
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]+)/,
      # 嵌入連結
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
    ]
    
    youtube_patterns.each do |pattern|
      result.gsub!(pattern) do |match|
        video_id = $1
        youtube_embed_html(video_id)
      end
    end
    
    # 標記為 HTML 安全，避免被 simple_format 轉義
    result.html_safe
  end
  
  # 清理殘留的 iframe 文字
  def clean_remaining_iframe_text(content)
    # 移除任何殘留的 iframe 相關文字
    content.gsub(/<iframe[^>]*>.*?<\/iframe>/mi, '').strip
  end
  
  # 處理已存在的 iframe 標籤
  def process_existing_iframes(content)
    # 更寬鬆的 iframe 匹配模式，處理各種格式
    iframe_patterns = [
      # 標準的 iframe 標籤
      /<iframe[^>]*src=["']https?:\/\/(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)[^>]*>.*?<\/iframe>/mi,
      # 不完整的 iframe 標籤（沒有結束標籤）
      /<iframe[^>]*src=["']https?:\/\/(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)[^>]*>/mi,
      # 包含額外參數的 iframe
      /<iframe[^>]*src=["']https?:\/\/(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)\?[^"']*["'][^>]*>.*?<\/iframe>/mi
    ]
    
    result = content.dup
    
    iframe_patterns.each do |pattern|
      result.gsub!(pattern) do |match|
        video_id = $1
        youtube_embed_html(video_id)
      end
    end
    
    result
  end
  
  # 生成 YouTube 內嵌 HTML
  def youtube_embed_html(video_id)
    content_tag(:div, class: "youtube-embed") do
      content_tag(:iframe, 
        nil,
        src: "https://www.youtube.com/embed/#{video_id}",
        width: "560",
        height: "415",
        frameborder: "0",
        allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
        allowfullscreen: true,
        class: "youtube-video"
      )
    end
  end
  
  # 檢查內容是否包含 YouTube 連結
  def has_youtube_links?(content)
    return false if content.blank?
    
    youtube_patterns = [
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
    ]
    
    youtube_patterns.any? { |pattern| content.match?(pattern) }
  end
end
