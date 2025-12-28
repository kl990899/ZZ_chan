# frozen_string_literal: true

# 服務類：處理 Cloudflare DNS 記錄更新
class CloudflareDnsService
  CLOUDFLARE_API_BASE = 'https://api.cloudflare.com/client/v4'
  IP_CHECK_SERVICES = [
    'https://api.ipify.org',
    'https://icanhazip.com',
    'https://ifconfig.me/ip'
  ].freeze

  attr_reader :api_token, :zone_id, :record_name, :record_type, :errors

  def initialize(api_token:, zone_id:, record_name:, record_type: 'A')
    @api_token = api_token
    @zone_id = zone_id
    @record_name = record_name
    @record_type = record_type
    @errors = []
  end

  def current_ip
    IP_CHECK_SERVICES.each do |service|
      response = Net::HTTP.get_response(URI(service))
      return response.body.strip
    rescue StandardError
      next
    end
    nil
  end

  def dns_record_id
    records = api_get("/zones/#{zone_id}/dns_records", name: record_name, type: record_type)
    return nil unless records&.any?

    records.first['id']
  end

  def current_dns_ip
    record_id = dns_record_id
    return nil unless record_id

    record = api_get("/zones/#{zone_id}/dns_records/#{record_id}")
    record&.dig('content')
  end

  def update_dns_record(new_ip)
    record_id = dns_record_id
    return false unless record_id

    current_record = api_get("/zones/#{zone_id}/dns_records/#{record_id}")
    return false unless current_record

    body = {
      type: record_type,
      name: record_name,
      content: new_ip,
      ttl: current_record['ttl'] || 1,
      proxied: current_record['proxied'] || false
    }

    !api_patch("/zones/#{zone_id}/dns_records/#{record_id}", body).nil?
  end

  def check_and_update
    current_ip = self.current_ip
    return error_result('無法獲取當前 IP 地址') unless current_ip

    current_dns_ip = self.current_dns_ip
    return error_result('無法獲取當前 DNS 記錄的 IP') unless current_dns_ip

    return no_change_result(current_ip, current_dns_ip) if current_ip == current_dns_ip

    update_result(current_ip, current_dns_ip)
  end

  private

  def api_get(path, params = {})
    uri = URI("#{CLOUDFLARE_API_BASE}#{path}")
    uri.query = URI.encode_www_form(params) if params.any?
    request = build_request(Net::HTTP::Get, uri)
    handle_response(make_request(uri, request))
  end

  def api_patch(path, body)
    uri = URI("#{CLOUDFLARE_API_BASE}#{path}")
    request = build_request(Net::HTTP::Patch, uri)
    request.body = body.to_json
    handle_response(make_request(uri, request))
  end

  def build_request(klass, uri)
    request = klass.new(uri)
    request['Authorization'] = "Bearer #{api_token}"
    request['Content-Type'] = 'application/json'
    request
  end

  def handle_response(response)
    return nil if response.nil? || !response.is_a?(Net::HTTPSuccess)

    result = JSON.parse(response.body)
    return nil unless result['success']

    result['result']
  rescue StandardError
    nil
  end

  def make_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 30
    http.request(request)
  rescue StandardError
    nil
  end

  def error_result(message)
    { success: false, message: message, errors: @errors }
  end

  def no_change_result(current_ip, dns_ip)
    {
      success: true,
      message: "IP 地址未變更 (#{current_ip})",
      current_ip: current_ip,
      dns_ip: dns_ip
    }
  end

  def update_result(current_ip, old_dns_ip)
    if update_dns_record(current_ip)
      {
        success: true,
        message: "DNS 記錄已更新: #{old_dns_ip} -> #{current_ip}",
        current_ip: current_ip,
        old_dns_ip: old_dns_ip
      }
    else
      {
        success: false,
        message: 'DNS 記錄更新失敗',
        errors: @errors,
        current_ip: current_ip,
        old_dns_ip: old_dns_ip
      }
    end
  end
end
