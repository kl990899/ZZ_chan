# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# 設定時區
set :output, "#{path}/log/cron.log"
set :environment, :production

# 每天凌晨 5 點執行 Cloudflare DNS 更新
# every 1.day, at: '5:00 am' do
#   rake 'cloudflare:update_dns'
# end

# 如果需要更頻繁的檢查（例如每小時），可以取消註解以下行：
# every 1.hour do
#   rake 'cloudflare:update_dns'
# end

# 如果需要每 6 小時檢查一次，可以使用：
every 3.hours do
  rake 'cloudflare:update_dns'
end

# 每 15 分鐘自動清除廣告/垃圾訊息
every 15.minutes do
  rake 'spam:cleanup'
end
