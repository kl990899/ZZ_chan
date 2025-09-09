class Post < ApplicationRecord
  belongs_to :discussion_thread
  has_one_attached :image
  has_one_attached :video
  
  # 驗證檔案類型
  validate :validate_image_content_type
  validate :validate_video_content_type
  
  # 驗證檔案大小
  validate :validate_image_size
  validate :validate_video_size
  
  # 確保不能同時上傳圖片和影片
  validate :cannot_have_both_image_and_video
  
  # 檢查是否包含 YouTube 連結
  def has_youtube_links?
    return false if content.blank?
    
    youtube_patterns = [
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
    ]
    
    youtube_patterns.any? { |pattern| content.match?(pattern) }
  end
  
  # 獲取 YouTube 影片 ID
  def youtube_video_ids
    return [] if content.blank?
    
    video_ids = []
    youtube_patterns = [
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]+)/,
      /(?:https?:\/\/)?(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)/
    ]
    
    youtube_patterns.each do |pattern|
      content.scan(pattern).each do |match|
        video_ids << match[0] if match[0]
      end
    end
    
    video_ids.uniq
  end
  
  private
  
  def validate_image_content_type
    return unless image.attached?
    
    unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
      errors.add(:image, "只支援 JPEG, PNG, GIF, WebP 格式")
    end
  end
  
  def validate_video_content_type
    return unless video.attached?
    
    unless video.content_type.in?(%w[video/mp4 video/webm video/ogg video/quicktime])
      errors.add(:video, "只支援 MP4, WebM, OGG, MOV 格式")
    end
  end
  
  def validate_image_size
    return unless image.attached?
    
    if image.byte_size > 5.megabytes
      errors.add(:image, "圖片大小不能超過 5MB")
    end
  end
  
  def validate_video_size
    return unless video.attached?
    
    if video.byte_size > 5.megabytes
      errors.add(:video, "影片大小不能超過 5MB")
    end
  end
  
  def cannot_have_both_image_and_video
    if image.attached? && video.attached?
      errors.add(:base, "不能同時上傳圖片和影片")
    end
  end
end