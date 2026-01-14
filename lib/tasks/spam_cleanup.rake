namespace :spam do
  desc '檢測並清除廣告/垃圾訊息'
  task cleanup: :environment do
    puts '開始檢測廣告/垃圾訊息...'
    puts '=' * 50

    # 檢測廣告討論串
    spam_threads = SpamDetectionService.find_spam_threads
    thread_count = spam_threads.count

    if thread_count.positive?
      puts "發現 #{thread_count} 個可能是廣告的討論串："
      spam_threads.each do |thread|
        puts "  - ID: #{thread.id}, 標題: #{thread.title&.truncate(50)}"
      end

      # 刪除廣告討論串（會自動刪除相關貼文，因為有 dependent: :destroy）
      deleted_count = 0
      spam_threads.each do |thread|
        thread.destroy
        deleted_count += 1
      end

      puts "已刪除 #{deleted_count} 個廣告討論串及其相關貼文"
    else
      puts '未發現廣告討論串'
    end

    puts '-' * 50

    # 檢測廣告貼文（不包括已刪除討論串的貼文）
    spam_posts = SpamDetectionService.find_spam_posts
    # 過濾掉已經被刪除的討論串的貼文
    spam_posts = spam_posts.select { |post| post.discussion_thread.present? }
    post_count = spam_posts.count

    if post_count.positive?
      puts "發現 #{post_count} 個可能是廣告的貼文："
      spam_posts.each do |post|
        thread_title = post.discussion_thread&.title&.truncate(30) || 'N/A'
        content_preview = post.content&.truncate(50) || 'N/A'
        puts "  - ID: #{post.id}, 討論串: #{thread_title}, 內容: #{content_preview}"
      end

      # 刪除廣告貼文
      deleted_count = 0
      spam_posts.each do |post|
        post.destroy
        deleted_count += 1
      end

      puts "已刪除 #{deleted_count} 個廣告貼文"
    else
      puts '未發現廣告貼文'
    end

    puts '=' * 50
    puts "清理完成！總共刪除 #{thread_count} 個討論串和 #{post_count} 個貼文"
  end

  desc '僅檢測廣告，不刪除（測試用）'
  task detect: :environment do
    puts '檢測廣告/垃圾訊息（僅檢測，不刪除）...'
    puts '=' * 50

    # 檢測廣告討論串
    spam_threads = SpamDetectionService.find_spam_threads
    thread_count = spam_threads.count

    if thread_count.positive?
      puts "發現 #{thread_count} 個可能是廣告的討論串："
      spam_threads.each do |thread|
        puts "  - ID: #{thread.id}, 標題: #{thread.title&.truncate(50)}, 建立時間: #{thread.created_at}"
      end
    else
      puts '未發現廣告討論串'
    end

    puts '-' * 50

    # 檢測廣告貼文
    spam_posts = SpamDetectionService.find_spam_posts
    spam_posts = spam_posts.select { |post| post.discussion_thread.present? }
    post_count = spam_posts.count

    if post_count.positive?
      puts "發現 #{post_count} 個可能是廣告的貼文："
      spam_posts.each do |post|
        thread_title = post.discussion_thread&.title&.truncate(30) || 'N/A'
        content_preview = post.content&.truncate(50) || 'N/A'
        puts "  - ID: #{post.id}, 討論串: #{thread_title}, 內容: #{content_preview}, 建立時間: #{post.created_at}"
      end
    else
      puts '未發現廣告貼文'
    end

    puts '=' * 50
    puts "檢測完成！總共發現 #{thread_count} 個討論串和 #{post_count} 個貼文可能是廣告"
  end
end
