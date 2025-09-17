module SitemapHelper
  def generate_direct_image_url(attachment)
    return nil unless attachment&.attached?

    # 使用 Rails 的 url_for 但確保生成正確的 URL
    begin
      # 設置 ActiveStorage 的 URL 選項
      ActiveStorage::Current.url_options = {
        host: 'zz-chan.org',
        protocol: 'https'
      }

      # 生成 URL 並替換 redirect 路徑
      url = url_for(attachment)
      url.gsub('/rails/active_storage/blobs/redirect/', '/rails/active_storage/blobs/')
    rescue StandardError
      # 如果失敗，使用 fallback 方法
      signed_id = attachment.signed_id
      filename = attachment.filename.to_s
      "https://zz-chan.org/rails/active_storage/blobs/#{signed_id}/#{filename}"
    end
  end

  def generate_direct_video_url(attachment)
    return nil unless attachment&.attached?

    # 使用 Rails 的 url_for 但確保生成正確的 URL
    begin
      # 設置 ActiveStorage 的 URL 選項
      ActiveStorage::Current.url_options = {
        host: 'zz-chan.org',
        protocol: 'https'
      }

      # 生成 URL 並替換 redirect 路徑
      url = url_for(attachment)
      url.gsub('/rails/active_storage/blobs/redirect/', '/rails/active_storage/blobs/')
    rescue StandardError
      # 如果失敗，使用 fallback 方法
      signed_id = attachment.signed_id
      filename = attachment.filename.to_s
      "https://zz-chan.org/rails/active_storage/blobs/#{signed_id}/#{filename}"
    end
  end

  def generate_video_thumbnail_url(attachment)
    return nil unless attachment&.attached?

    # 對於影片，生成一個預設的縮圖 URL
    if attachment.previewable?
      begin
        # 嘗試生成預覽縮圖
        preview = attachment.preview(resize_to_limit: [640, 480])
        ActiveStorage::Current.url_options = {
          host: 'zz-chan.org',
          protocol: 'https'
        }

        url = url_for(preview)
        url.gsub('/rails/active_storage/blobs/redirect/', '/rails/active_storage/blobs/')
      rescue StandardError
        # 如果無法生成預覽，使用預設縮圖
        'https://zz-chan.org/og-default-1200x630.html'
      end
    else
      # 如果無法預覽，使用預設縮圖
      'https://zz-chan.org/og-default-1200x630.html'
    end
  end
end
