# ZZ_chan

一個基於 Rails 7.2 的討論板應用程式，採用 Actor 模式進行業務邏輯處理，並使用 Blueprinter 進行資料序列化。

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

### 主要功能
- 討論串建立與管理
- 貼文發布與回覆
- 圖片與影片上傳 (支援 JPEG, PNG, GIF, WebP, MP4, WebM)
- YouTube 影片嵌入
- IP 地址雜湊處理
- 分頁顯示

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

## 專案結構

```
app/
├── actors/                 # Actor 模式業務邏輯
│   ├── discussion_thread/ # 討論串相關 Actors
│   └── post/             # 貼文相關 Actors
├── blueprints/           # Blueprinter 序列化定義
│   ├── discussion_thread/
│   └── post/
├── controllers/          # Rails 控制器
├── models/              # ActiveRecord 模型
├── views/               # ERB 模板
└── helpers/             # 視圖輔助方法
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

### 程式碼風格
專案使用 Rubocop 進行程式碼風格檢查：

```bash
# 檢查程式碼風格
bundle exec rubocop

# 自動修正可修正的問題
bundle exec rubocop -a
```

## 部署

### 生產環境設定
1. 設定環境變數
2. 配置 Nginx + Passenger
3. 設定 MySQL 資料庫
4. 執行資料庫遷移
5. 預編譯資產

### 建議的 Nginx 配置
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    root /path/to/ZZ_chan/public;
    
    passenger_enabled on;
    passenger_ruby /path/to/ruby;
    
    location / {
        try_files $uri @app;
    }
    
    location @app {
        passenger_enabled on;
    }
}
```

## 測試

```bash
# 執行所有測試
rails test

# 執行系統測試
rails test:system

# 執行特定測試
rails test test/models/discussion_thread_test.rb
```

## 貢獻指南

1. Fork 專案
2. 建立功能分支
3. 提交變更
4. 推送到分支
5. 建立 Pull Request

## 授權

此專案採用 MIT 授權條款。

## 聯絡資訊

如有問題或建議，請透過 GitHub Issues 聯繫。
