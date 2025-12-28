# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

namespace :cloudflare do
  desc '檢查並更新 Cloudflare DNS 記錄的動態 IP'
  task update_dns: :environment do
    config = load_config
    exit 1 unless valid_config?(config)

    puts "開始檢查 DNS 記錄: #{config[:record_name]}"
    service = CloudflareDnsService.new(**config)
    result = service.check_and_update

    puts result[:success] ? "✓ #{result[:message]}" : "✗ #{result[:message]}"
    puts "  舊 IP: #{result[:old_dns_ip]}" if result[:old_dns_ip]
    puts "  新 IP: #{result[:current_ip]}" if result[:current_ip]
    exit 1 unless result[:success]
  end

  desc '測試 Cloudflare DNS 配置'
  task test: :environment do
    config = load_config
    exit 1 unless valid_config?(config)

    puts "記錄名稱: #{config[:record_name]}"
    puts "Zone ID: #{config[:zone_id]}"
    puts ''

    service = CloudflareDnsService.new(**config)
    current_ip = service.current_ip
    dns_ip = service.current_dns_ip

    puts current_ip ? "✓ 當前 IP: #{current_ip}" : '✗ 無法獲取當前 IP'
    puts dns_ip ? "✓ DNS IP: #{dns_ip}" : '✗ 無法獲取 DNS IP'

    return unless current_ip && dns_ip

    puts current_ip == dns_ip ? '✓ IP 一致' : "⚠ IP 不一致: #{dns_ip} -> #{current_ip}"
  end

  desc '列出所有 DNS 記錄'
  task list_records: :environment do
    config = load_config
    exit 1 unless config[:api_token] && config[:zone_id]

    uri = URI("https://api.cloudflare.com/client/v4/zones/#{config[:zone_id]}/dns_records")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{config[:api_token]}"
    request['Content-Type'] = 'application/json'

    response = Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
      http.read_timeout = 30
    end.request(request)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      if result['success'] && result['result']&.any?
        result['result'].each do |record|
          puts "#{record['name']} #{record['type']} #{record['content']}"
        end
      end
    end
  end

  desc '驗證 API Token'
  task verify_token: :environment do
    api_token = ENV['CLOUDFLARE_API_TOKEN'] || Rails.application.credentials.dig(:cloudflare, :api_token)
    exit 1 unless api_token

    uri = URI('https://api.cloudflare.com/client/v4/user/tokens/verify')
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{api_token}"

    response = Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
    end.request(request)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      puts result['success'] ? '✓ Token 有效' : '✗ Token 無效'
    end
  end

  desc '獲取 Zone ID'
  task :get_zone_id, [:domain] => :environment do |_t, args|
    api_token = ENV['CLOUDFLARE_API_TOKEN'] || Rails.application.credentials.dig(:cloudflare, :api_token)
    domain = args[:domain] || ENV.fetch('CLOUDFLARE_DOMAIN', nil)
    exit 1 unless api_token && domain

    uri = URI("https://api.cloudflare.com/client/v4/zones?name=#{domain}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{api_token}"

    response = Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
    end.request(request)

    if response.is_a?(Net::HTTPSuccess)
      result = JSON.parse(response.body)
      puts "Zone ID: #{result['result'].first['id']}" if result['success'] && result['result']&.any?
    end
  end

  private

  def load_config
    {
      api_token: ENV['CLOUDFLARE_API_TOKEN'] || Rails.application.credentials.dig(:cloudflare, :api_token),
      zone_id: ENV['CLOUDFLARE_ZONE_ID'] || Rails.application.credentials.dig(:cloudflare, :zone_id),
      record_name: ENV['CLOUDFLARE_RECORD_NAME'] || Rails.application.credentials.dig(:cloudflare, :record_name),
      record_type: ENV['CLOUDFLARE_RECORD_TYPE'] || 'A'
    }
  end

  def valid_config?(config)
    return true if config[:api_token] && config[:zone_id] && config[:record_name]

    puts '錯誤：缺少必要的配置'
    false
  end
end
