require 'blueprinter'

class Post::InfoBlueprint < Blueprinter::Base
  identifier :id

  fields :name,
         :content,
         :ip_address,
         :hashed_ip

  field :created_at do |post|
    post.created_at.strftime('%Y/%m/%d(%a) %H:%M:%S')
  end

  field :updated_at do |post|
    post.updated_at.strftime('%Y/%m/%d(%a) %H:%M:%S')
  end

  field :has_image do |post|
    post.image.attached?
  end

  field :has_video do |post|
    post.video.attached?
  end

  field :image_url do |post|
    Rails.application.routes.url_helpers.rails_blob_url(post.image, only_path: true) if post.image.attached?
  end

  field :video_url do |post|
    Rails.application.routes.url_helpers.rails_blob_url(post.video, only_path: true) if post.video.attached?
  end

  field :video_content_type do |post|
    post.video.attached? ? post.video.blob.content_type : nil
  end

  field :image_filename do |post|
    post.image.attached? ? post.image.blob.filename.to_s : nil
  end

  field :image_byte_size do |post|
    post.image.attached? ? post.image.blob.byte_size : nil
  end

  field :video_filename do |post|
    post.video.attached? ? post.video.blob.filename.to_s : nil
  end

  field :video_byte_size do |post|
    post.video.attached? ? post.video.blob.byte_size : nil
  end

  field :has_youtube_links, &:youtube_links?

  field :youtube_video_ids, &:youtube_video_ids

  view :list do
    # 使用頂層已定義的欄位，無需重複定義
    # 只包含 list view 需要的欄位
    exclude :ip_address
    exclude :updated_at
    exclude :video_content_type
    exclude :youtube_video_ids
  end

  view :show do
    # 使用頂層已定義的欄位，無需重複定義
  end
end
