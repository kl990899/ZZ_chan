# ZZ_chan

<div align="center">

**🌐 語言 / Language / 言語**

[![繁體中文](https://img.shields.io/badge/繁體中文-當前語言-brightgreen)](README.md)
[![日本語](https://img.shields.io/badge/日本語-Japanese-blue)](README.ja.md)

</div>

---

一個基於 Rails 7.2 的討論板應用程式，採用 Actor 模式進行業務邏輯處理，並使用 Blueprinter 進行資料序列化。

> **作者**: Zan Zas  
> **授權**: MIT License  
> **開源狀態**: 完全開源，歡迎貢獻

## 技術規格

### 核心技術
- **Ruby**: 3.1.4
- **Rails**: 7.2.2.1
- **資料庫**: MySQL 5.5.8+
- **Web 伺服器**: Puma 5.0+
- **分頁**: Kaminari
- **檔案處理**: Active Storage

### 架構模式
- **Actor Pattern**: 使用 `service_actor` gem 進行業務邏輯封裝
- **資料序列化**: 使用 `blueprinter` gem 進行 JSON 序列化
- **程式碼風格**: 使用 `rubocop` 進行程式碼檢查

### SEO 與社群分享技術
- **Open Graph**: 動態生成 OG 標籤
- **Twitter Cards**: 支援社群媒體預覽
- **結構化資料**: JSON-LD 格式
- **圖片處理**: ActiveStorage + 響應式 URL
- **快取管理**: Cloudflare 快取策略
- **LINE 預覽**: 優化分享預覽顯示

### 硬體環境
- **主機**: GIGABYTE BRIX BPCE-3350C 微型準系統
- **CPU**: Intel Celeron N3350 @ 1.1GHz (最高 2.4GHz)
- **記憶體**: 8GB DDR3L
- **儲存**: 128GB SSD
- **網路**: 內建 Gigabit Ethernet

<details>
<summary> check out my brand new potato pc </summary>

### 🐰potato🥚
![GIGABYTE BRIX BPCE-3350C 主機照片](public/206896.jpg)

### 硬體規格詳情
- **型號**: GIGABYTE BRIX BPCE-3350C
- **尺寸**: 110 x 100 x 50mm
- **重量**: 約 0.5kg
- **電源**: 19V/3.42A 外接變壓器
- **散熱**: 被動式散熱設計，無風扇運作
- **I/O 介面**: 
  - 2x USB 3.0
  - 2x USB 2.0
  - 1x HDMI 2.0
  - 1x DisplayPort 1.2
  - 1x Gigabit Ethernet
  - 1x 3.5mm 音訊孔
  - 1x SD 卡讀卡機

### 效能表現
- **待機功耗**: < 10W
- **滿載功耗**: < 15W
- **噪音**: 0dB (無風扇設計)
- **溫度**: 待機 35°C，滿載 65°C
- **穩定性**: 24/7 

</details>

### 網路設定
- **網路環境**: 中華電信家用寬頻網路
- **路由器**: H660WM-C (中華電信租借路由器)
- **DHCP 設定**: 預留 IP 轉發固定內網 (192.168.1.XXX)
- **NAT 設定**: 轉發接口設定
  - 外部埠 8080 → 內部 192.168.1.XXX:8080 (HTTP)
  - 外部埠 8443 → 內部 192.168.1.XXX:8443 (HTTPS)
  - 外部埠 8880 → 內部 192.168.1.XXX:8880 (HTTP 備用)

### CDN 與 SSL 設定
- **CDN 服務**: Cloudflare
- **域名**: zz-chan.org
- **代理狀態**: 已啟用 Cloudflare 代理
- **SSL/TLS 模式**: Full (端到端加密)
- **特殊規則設定**:
  - HTTPS 請求重寫至埠 8443
  - HTTP 請求重寫至埠 8880

### 主要功能
- **討論串管理**:
  - 討論串建立與管理
  - 貼文發布與回覆
  - 分頁顯示與搜尋

- **多媒體支援**:
  - 圖片上傳 (支援 JPEG, PNG, GIF, WebP)
  - 影片上傳 (支援 MP4, WebM)
  - YouTube 影片嵌入與縮圖顯示
  - 檔案大小限制 (最大 5MB)

- **SEO 優化**:
  - Open Graph 標籤自動生成
  - 動態 meta 標籤設定
  - 結構化資料 (JSON-LD)
  - 自動生成 sitemap.xml
  - robots.txt 配置
  - 響應式圖片 URL 生成

- **社群分享**:
  - LINE 分享預覽優化
  - Facebook 分享支援
  - Twitter Card 支援
  - 自動縮圖生成 (圖片/YouTube/影片)

- **安全性與隱私**:
  - IP 地址雜湊處理
  - 匿名發文支援
  - 檔案類型驗證
  - XSS 防護

- **使用者體驗**:
  - 響應式設計
  - 深色/淺色主題切換
  - 圖片點擊放大功能
  - 年齡驗證機制

## 系統需求

### 必要軟體
- Ruby 3.1.4
- MySQL 5.5.8 或更高版本
- Node.js (用於 Asset Pipeline)
- Bundler

### 建議環境
- **開發環境**: Puma + MySQL
- **生產環境**: Nginx + Passenger + MySQL
- **作業系統**: Linux (Ubuntu 20.04+ 推薦)

## 安裝與設定

### 1. 克隆專案
```bash
git clone <repository-url>
cd ZZ_chan
```

### 2. 安裝依賴
```bash
bundle install
```

### 3. 資料庫設定
```bash
# 建立資料庫
rails db:create

# 執行遷移
rails db:migrate

# 載入種子資料 (可選)
rails db:seed
```

### 4. 環境變數設定
建立 `.env` 檔案並設定以下變數：
```bash
# 資料庫設定
DATABASE_URL=mysql2://root:MyRootPass#2025@localhost/zz_chan_development

# Rails 設定
RAILS_ENV=development
RAILS_LOG_LEVEL=info
```

### 5. 啟動應用程式
```bash
# 開發環境
rails server

# 或使用 Puma 直接啟動
bundle exec puma
```

## 系統架構
### 網路拓撲
```
Internet → Cloudflare CDN → 中華電信家用寬頻 → H660WM-C Router → GIGABYTE BRIX (192.168.1.XXX)
    ↓           ↓              ↓                    ↓
  HTTP/HTTPS  Cloudflare   中華電信光纖網路    NAT Port Forwarding
  Requests    Rules        (動態IP)           - 8080 → 8080 (HTTP)
              - 80 → 8880                    - 8443 → 8443 (HTTPS)
              - 443 → 8443                   - 8880 → 8880 (HTTP 備用)
              - SSL/TLS Full
              - Proxy Enabled
```

### Cloudflare 規則設定
1. **HTTP 重寫規則**:
   - 條件: `Hostname equals zz-chan.org AND SSL/HTTPS does not equal true`
   - 動作: `Rewrite port to 8880`
   - 說明: 將所有 HTTP 請求 (埠 80) 重寫至內部埠 8880

2. **HTTPS 重寫規則**:
   - 條件: `Hostname equals zz-chan.org AND SSL/HTTPS equals true`
   - 動作: `Rewrite port to 8443`
   - 說明: 將所有 HTTPS 請求 (埠 443) 重寫至內部埠 8443

3. **SSL/TLS 設定**:
   - 加密模式: Full (端到端加密)
   - 邊緣憑證: 由 Cloudflare 自動管理
   - 來源憑證: 需要配置或使用 Cloudflare Origin CA

### 服務架構
```
Cloudflare (CDN + SSL)
    ↓
Nginx (反向代理 + 靜態檔案)
    ↓
Passenger (Rails 應用程式)
    ↓
MySQL (資料庫)
```

## 專案結構

```
app/
├── actors/                 # Actor 模式業務邏輯
│   ├── discussion_thread/ # 討論串相關 Actors
│   │   ├── create.rb     # 建立討論串
│   │   ├── list.rb       # 討論串列表
│   │   ├── find.rb       # 查找討論串
│   │   └── seo_data.rb   # SEO 資料生成
│   └── post/             # 貼文相關 Actors
│       ├── create.rb     # 建立貼文
│       └── list.rb       # 貼文列表
├── blueprints/           # Blueprinter 序列化定義
│   ├── discussion_thread/
│   └── post/
├── controllers/          # Rails 控制器
│   ├── sitemap_controller.rb  # Sitemap 生成
│   └── robots_controller.rb   # Robots.txt 生成
├── models/              # ActiveRecord 模型
├── views/               # ERB 模板
│   ├── layouts/
│   │   └── application.html.erb  # 包含 SEO meta 標籤
│   └── sitemap/
│       └── index.xml.erb         # Sitemap XML 模板
├── helpers/             # 視圖輔助方法
│   └── seo_helper.rb    # SEO 相關 Helper 方法
└── assets/              # 靜態資源
    └── stylesheets/
        └── application.css       # 包含響應式設計
```

## 資料庫結構

### DiscussionThread (討論串)
- `id`: 主鍵
- `name`: 發文者名稱
- `title`: 討論串標題
- `created_at`: 建立時間
- `updated_at`: 更新時間

### Post (貼文)
- `id`: 主鍵
- `discussion_thread_id`: 所屬討論串 ID
- `name`: 發文者名稱
- `content`: 貼文內容
- `ip_address`: IP 地址
- `hashed_ip`: 雜湊後的 IP 地址
- `image`: 圖片附件 (Active Storage)
- `video`: 影片附件 (Active Storage)
- `created_at`: 建立時間
- `updated_at`: 更新時間

## 開發指南

### Actor 模式使用
所有業務邏輯都封裝在 Actor 中，遵循單一職責原則：

```ruby
# 範例：建立討論串
result = DiscussionThread::Create.call(
  params: params,
  request_ip: request.remote_ip
)

if result.success?
  # 處理成功情況
else
  # 處理錯誤情況
end
```

### Blueprinter 序列化
使用 Blueprinter 進行資料序列化：

```ruby
# 在視圖中使用
thread_data = discussion_thread_data(thread, view: :show)
post_data = post_data(post, view: :list)
```

### SEO 與社群分享開發
使用 Actor 模式處理 SEO 資料生成：

```ruby
# 生成討論串 SEO 資料
seo_result = DiscussionThread::SeoData.call(discussion_thread: thread)

if seo_result.success?
  @seo_data = seo_result
  # 在視圖中使用 @seo_data.title, @seo_data.og_data 等
end
```

使用 Helper 方法處理社群分享：

```ruby
# 在視圖中設定 Open Graph 標籤
content_for :og_image, @seo_data.og_data[:image]
content_for :og_title, @seo_data.og_data[:title]
content_for :og_description, @seo_data.og_data[:description]
```

### 程式碼風格
專案使用 Rubocop 進行程式碼風格檢查：

```bash
# 檢查程式碼風格
bundle exec rubocop

# 自動修正可修正的問題
bundle exec rubocop -a
```

## 部署

### 中華電信家用寬頻架設技術

#### 網路環境準備
1. **中華電信光纖網路**:
   - 申請固定 IP 或使用動態 IP + DDNS
   - 確認上傳頻寬足夠 (建議至少 10Mbps)
   - 檢查防火牆設定

2. **H660WM-C 路由器設定**:
   - 登入路由器管理介面 (通常為 192.168.1.1)
   - 設定 DHCP 保留 IP 給伺服器
   - 配置 NAT 埠轉發規則
   - 啟用 UPnP (可選)

3. **動態 IP 處理**:
   - 使用 Cloudflare 代理隱藏真實 IP
   - 設定 DDNS 服務 (如 No-IP, DuckDNS)
   - 定期更新 DNS 記錄

#### 架設步驟
1. **硬體準備**:
   - GIGABYTE BRIX 微型準系統
   - 安裝 Ubuntu Server 或 CentOS
   - 配置靜態內網 IP

2. **軟體環境**:
   - 安裝 Ruby, Rails, MySQL
   - 配置 Nginx + Passenger
   - 設定防火牆規則

3. **網路配置**:
   - 設定路由器埠轉發
   - 配置 Cloudflare DNS
   - 測試外部連線

### 生產環境設定
1. 設定環境變數
2. 配置 Nginx + Passenger
3. 設定 MySQL 資料庫
4. 執行資料庫遷移
5. 預編譯資產

### 建議的 Nginx 配置
```nginx
# HTTP 重定向到 HTTPS
server {
    listen 8443 ssl;
    server_name zz-chan.org www.zz-chan.org;

    root /home/zan/ZZ_chan/public;
    passenger_enabled on;
    passenger_app_env production;
    passenger_ruby /home/zan/.rvm/wrappers/ruby-3.1.4/ruby;

    client_max_body_size 10M;

    ssl_certificate /etc/ssl/zz-chan/fullchain.pem;
    ssl_certificate_key /etc/ssl/zz-chan/origin.key;

    location / {
        try_files $uri @app;
    }
    location @app {
        passenger_enabled on;
    }
}
server {
    listen 8880;  # Cloudflare 可以用的 HTTP
    server_name zz-chan.org www.zz-chan.org;
    return 301 https://$host:8443$request_uri;
}
```

### Cloudflare 設定
1. **DNS 設定**:
   - A 記錄: zz-chan.org → XXX.XXX.XXX.XXX (您的公網 IP)
   - 代理狀態: 已啟用 (橙色雲朵圖示)
   - TTL: Auto

2. **SSL/TLS 設定**:
   - 加密模式: Full (端到端加密)
   - 邊緣憑證: 由 Cloudflare 自動管理
   - 來源憑證: 使用 Cloudflare Origin CA 或自簽憑證

3. **規則設定** (Rules → Origin Rules):
   - **規則 1 - HTTP 重寫**:
     - 名稱: "Http Redirect to 8880"
     - 匹配條件: `Hostname equals zz-chan.org AND SSL/HTTPS does not equal true`
     - 動作: `Rewrite port to 8880`
     - 狀態: Active
   
   - **規則 2 - HTTPS 重寫**:
     - 名稱: "Https Redirect to 8443"
     - 匹配條件: `Hostname equals zz-chan.org AND SSL/HTTPS equals true`
     - 動作: `Rewrite port to 8443`
     - 狀態: Active

4. **快取設定**:
   - 快取層級: Standard
   - 瀏覽器快取 TTL: 4 小時
   - 邊緣快取 TTL: 2 小時

### 環境變數設定
```bash
# 生產環境變數
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_LEVEL=info

# 資料庫設定
DATABASE_URL=mysql2://username:password@localhost/zz_chan_production

# 安全設定
RAILS_MASTER_KEY=your_master_key_here
SECRET_KEY_BASE=your_secret_key_base_here

# 網址設定
RAILS_HOST=zz-chan.org
RAILS_PROTOCOL=https
```

## 效能與監控

### 硬體效能
- **CPU 使用率**: 平均 < 30% (Intel Celeron N3350)
- **記憶體使用**: 約 2-3GB (8GB 總容量)
- **磁碟 I/O**: SSD 提供快速讀寫
- **網路頻寬**: Gigabit Ethernet 提供充足頻寬

### 家用寬頻效能考量
- **上傳頻寬**: 中華電信家用寬頻上傳通常較下載慢
- **動態 IP**: 可能影響連線穩定性，建議使用 Cloudflare 代理
- **路由器效能**: H660WM-C 處理能力有限，避免過多並發連線
- **電力消耗**: 微型準系統耗電量低，適合 24/7 運行，預估每年電費67NTD

### 應用程式效能
- **回應時間**: 平均 < 200ms
- **並發處理**: 支援 50+ 同時連線
- **檔案上傳**: 支援最大 5MB 檔案
- **資料庫查詢**: 使用索引優化查詢效能

## 貢獻指南

1. Fork 專案
2. 建立功能分支
3. 提交變更
4. 推送到分支
5. 建立 Pull Request

## 授權

此專案採用 MIT 授權條款，歡迎開源使用。

### 開源聲明
- **原作者**: Zan Zas
- **授權方式**: MIT License
- **開源狀態**: 完全開源，歡迎 Fork 和貢獻

### 使用條款
使用本專案時，請：
1. 保留原始授權聲明
2. 在適當位置標明原作者 "Zan Zas"
3. 如進行重大修改，建議在 README 中說明修改內容

### MIT 授權條款
```
MIT License

Copyright (c) 2025 Zan Zas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 聯絡資訊

如有問題或建議，請透過 GitHub Issues 聯繫。
