# ZZ_chan

<div align="center">

**🌐 語言 / Language / 言語**

[![繁體中文](https://img.shields.io/badge/繁體中文-Chinese%20Traditional-green)](README.md)
[![日本語](https://img.shields.io/badge/日本語-現在の言語-brightgreen)](README.ja.md)

</div>

---

Rails 7.2 ベースの掲示板アプリケーション。Actor パターンでビジネスロジックを処理し、Blueprinter でデータシリアライゼーションを行います。

> **作者**: Zan Zas  
> **ライセンス**: MIT License  
> **オープンソース状態**: 完全オープンソース、貢献を歓迎します

## 技術仕様

### コア技術
- **Ruby**: 3.1.4
- **Rails**: 7.2.2.1
- **データベース**: MySQL 5.5.8+
- **Web サーバー**: Puma 5.0+
- **ページネーション**: Kaminari
- **ファイル処理**: Active Storage

### アーキテクチャパターン
- **Actor Pattern**: `service_actor` gem を使用してビジネスロジックをカプセル化
- **データシリアライゼーション**: `blueprinter` gem を使用して JSON シリアライゼーション
- **コードスタイル**: `rubocop` を使用してコードチェック

### SEO とソーシャルシェア技術
- **Open Graph**: 動的 OG タグ生成
- **Twitter Cards**: ソーシャルメディアプレビュー対応
- **構造化データ**: JSON-LD 形式
- **画像処理**: ActiveStorage + レスポンシブ URL
- **キャッシュ管理**: Cloudflare キャッシュ戦略
- **LINE プレビュー**: シェアプレビュー表示の最適化

### ハードウェア環境
- **ホスト**: GIGABYTE BRIX BPCE-3350C ミニ準システム
- **CPU**: Intel Celeron N3350 @ 1.1GHz (最大 2.4GHz)
- **メモリ**: 8GB DDR3L
- **ストレージ**: 128GB SSD
- **ネットワーク**: 内蔵 Gigabit Ethernet

<details>
<summary> check out my brand new potato pc </summary>

### 🐰potato🥚
![GIGABYTE BRIX BPCE-3350C ホスト写真](public/206896.jpg)

### ハードウェア仕様詳細
- **モデル**: GIGABYTE BRIX BPCE-3350C
- **サイズ**: 110 x 100 x 50mm
- **重量**: 約 0.5kg
- **電源**: 19V/3.42A 外部アダプター
- **冷却**: パッシブ冷却設計、ファンレス動作
- **I/O インターフェース**: 
  - 2x USB 3.0
  - 2x USB 2.0
  - 1x HDMI 2.0
  - 1x DisplayPort 1.2
  - 1x Gigabit Ethernet
  - 1x 3.5mm オーディオジャック
  - 1x SD カードリーダー

### パフォーマンス
- **待機消費電力**: < 10W
- **最大負荷消費電力**: < 15W
- **騒音**: 0dB (ファンレス設計)
- **温度**: 待機 35°C、最大負荷 65°C
- **安定性**: 24/7 稼働

</details>

### ネットワーク設定
- **ネットワーク環境**: 中華電信家庭用ブロードバンドネットワーク
- **ルーター**: H660WM-C (中華電信レンタルルーター)
- **DHCP 設定**: IP 転送固定内網予約 (192.168.1.XXX)
- **NAT 設定**: 転送インターフェース設定
  - 外部ポート 8080 → 内部 192.168.1.XXX:8080 (HTTP)
  - 外部ポート 8443 → 内部 192.168.1.XXX:8443 (HTTPS)
  - 外部ポート 8880 → 内部 192.168.1.XXX:8880 (HTTP バックアップ)

### CDN と SSL 設定
- **CDN サービス**: Cloudflare
- **ドメイン**: zz-chan.org
- **プロキシ状態**: Cloudflare プロキシ有効
- **SSL/TLS モード**: Full (エンドツーエンド暗号化)
- **特殊ルール設定**:
  - HTTPS リクエストをポート 8443 に書き換え
  - HTTP リクエストをポート 8880 に書き換え

### 主な機能
- **スレッド管理**:
  - スレッド作成と管理
  - 投稿と返信
  - ページネーション表示と検索

- **マルチメディア対応**:
  - 画像アップロード (JPEG, PNG, GIF, WebP 対応)
  - 動画アップロード (MP4, WebM 対応)
  - YouTube 動画埋め込みとサムネイル表示
  - ファイルサイズ制限 (最大 5MB)

- **SEO 最適化**:
  - Open Graph タグ自動生成
  - 動的 meta タグ設定
  - 構造化データ (JSON-LD)
  - sitemap.xml 自動生成
  - robots.txt 設定
  - レスポンシブ画像 URL 生成

- **ソーシャルシェア**:
  - LINE シェアプレビュー最適化
  - Facebook シェア対応
  - Twitter Card 対応
  - 自動サムネイル生成 (画像/YouTube/動画)

- **セキュリティとプライバシー**:
  - IP アドレスハッシュ処理
  - 匿名投稿対応
  - ファイルタイプ検証
  - XSS 対策

- **ユーザー体験**:
  - レスポンシブデザイン
  - ダーク/ライトテーマ切り替え
  - 画像クリック拡大機能
  - 年齢確認メカニズム

## システム要件

### 必要なソフトウェア
- Ruby 3.1.4
- MySQL 5.5.8 以上
- Node.js (Asset Pipeline 用)
- Bundler

### 推奨環境
- **開発環境**: Puma + MySQL
- **本番環境**: Nginx + Passenger + MySQL
- **オペレーティングシステム**: Linux (Ubuntu 20.04+ 推奨)

## インストールと設定

### 1. プロジェクトのクローン
```bash
git clone <repository-url>
cd ZZ_chan
```

### 2. 依存関係のインストール
```bash
bundle install
```

### 3. データベース設定
```bash
# データベース作成
rails db:create

# マイグレーション実行
rails db:migrate

# シードデータ読み込み (オプション)
rails db:seed
```

### 4. 環境変数設定
`.env` ファイルを作成し、以下の変数を設定：
```bash
# データベース設定
DATABASE_URL=mysql2://root:MyRootPass#2025@localhost/zz_chan_development

# Rails 設定
RAILS_ENV=development
RAILS_LOG_LEVEL=info
```

### 5. アプリケーション起動
```bash
# 開発環境
rails server

# または Puma で直接起動
bundle exec puma
```

## システムアーキテクチャ
### ネットワークトポロジー
```
Internet → Cloudflare CDN → 中華電信家庭用ブロードバンド → H660WM-C Router → GIGABYTE BRIX (192.168.1.XXX)
    ↓           ↓              ↓                    ↓
  HTTP/HTTPS  Cloudflare   中華電信光ファイバー    NAT Port Forwarding
  Requests    Rules        (動的IP)               - 8080 → 8080 (HTTP)
              - 80 → 8880                    - 8443 → 8443 (HTTPS)
              - 443 → 8443                   - 8880 → 8880 (HTTP バックアップ)
              - SSL/TLS Full
              - Proxy Enabled
```

### Cloudflare ルール設定
1. **HTTP 書き換えルール**:
   - 条件: `Hostname equals zz-chan.org AND SSL/HTTPS does not equal true`
   - アクション: `Rewrite port to 8880`
   - 説明: すべての HTTP リクエスト (ポート 80) を内部ポート 8880 に書き換え

2. **HTTPS 書き換えルール**:
   - 条件: `Hostname equals zz-chan.org AND SSL/HTTPS equals true`
   - アクション: `Rewrite port to 8443`
   - 説明: すべての HTTPS リクエスト (ポート 443) を内部ポート 8443 に書き換え

3. **SSL/TLS 設定**:
   - 暗号化モード: Full (エンドツーエンド暗号化)
   - エッジ証明書: Cloudflare が自動管理
   - オリジン証明書: 設定が必要、または Cloudflare Origin CA を使用

### サービスアーキテクチャ
```
Cloudflare (CDN + SSL)
    ↓
Nginx (リバースプロキシ + 静的ファイル)
    ↓
Passenger (Rails アプリケーション)
    ↓
MySQL (データベース)
```

## プロジェクト構造

```
app/
├── actors/                 # Actor パターンビジネスロジック
│   ├── discussion_thread/ # スレッド関連 Actors
│   │   ├── create.rb     # スレッド作成
│   │   ├── list.rb       # スレッド一覧
│   │   ├── find.rb       # スレッド検索
│   │   └── seo_data.rb   # SEO データ生成
│   └── post/             # 投稿関連 Actors
│       ├── create.rb     # 投稿作成
│       └── list.rb       # 投稿一覧
├── blueprints/           # Blueprinter シリアライゼーション定義
│   ├── discussion_thread/
│   └── post/
├── controllers/          # Rails コントローラー
│   ├── sitemap_controller.rb  # Sitemap 生成
│   └── robots_controller.rb   # Robots.txt 生成
├── models/              # ActiveRecord モデル
├── views/               # ERB テンプレート
│   ├── layouts/
│   │   └── application.html.erb  # SEO meta タグを含む
│   └── sitemap/
│       └── index.xml.erb         # Sitemap XML テンプレート
├── helpers/             # ビューヘルパーメソッド
│   └── seo_helper.rb    # SEO 関連 Helper メソッド
└── assets/              # 静的リソース
    └── stylesheets/
        └── application.css       # レスポンシブデザインを含む
```

## データベース構造

### DiscussionThread (スレッド)
- `id`: 主キー
- `name`: 投稿者名
- `title`: スレッドタイトル
- `created_at`: 作成日時
- `updated_at`: 更新日時

### Post (投稿)
- `id`: 主キー
- `discussion_thread_id`: 所属スレッド ID
- `name`: 投稿者名
- `content`: 投稿内容
- `ip_address`: IP アドレス
- `hashed_ip`: ハッシュ化された IP アドレス
- `image`: 画像添付 (Active Storage)
- `video`: 動画添付 (Active Storage)
- `created_at`: 作成日時
- `updated_at`: 更新日時

## 開発ガイド

### Actor パターンの使用
すべてのビジネスロジックは Actor にカプセル化され、単一責任の原則に従います：

```ruby
# 例：スレッド作成
result = DiscussionThread::Create.call(
  params: params,
  request_ip: request.remote_ip
)

if result.success?
  # 成功時の処理
else
  # エラー時の処理
end
```

### Blueprinter シリアライゼーション
Blueprinter を使用してデータシリアライゼーション：

```ruby
# ビューで使用
thread_data = discussion_thread_data(thread, view: :show)
post_data = post_data(post, view: :list)
```

### SEO とソーシャルシェア開発
Actor パターンを使用して SEO データ生成を処理：

```ruby
# スレッド SEO データ生成
seo_result = DiscussionThread::SeoData.call(discussion_thread: thread)

if seo_result.success?
  @seo_data = seo_result
  # ビューで @seo_data.title, @seo_data.og_data などを使用
end
```

Helper メソッドを使用してソーシャルシェアを処理：

```ruby
# ビューで Open Graph タグを設定
content_for :og_image, @seo_data.og_data[:image]
content_for :og_title, @seo_data.og_data[:title]
content_for :og_description, @seo_data.og_data[:description]
```

### コードスタイル
プロジェクトは Rubocop を使用してコードスタイルをチェック：

```bash
# コードスタイルチェック
bundle exec rubocop

# 自動修正可能な問題を修正
bundle exec rubocop -a
```

## デプロイ

### 中華電信家庭用ブロードバンド構築技術

#### ネットワーク環境準備
1. **中華電信光ファイバーネットワーク**:
   - 固定 IP 申請または動的 IP + DDNS 使用
   - アップロード帯域幅が十分であることを確認 (推奨: 最低 10Mbps)
   - ファイアウォール設定を確認

2. **H660WM-C ルーター設定**:
   - ルーター管理インターフェースにログイン (通常 192.168.1.1)
   - サーバー用 DHCP 予約 IP を設定
   - NAT ポート転送ルールを設定
   - UPnP を有効化 (オプション)

3. **動的 IP 処理**:
   - Cloudflare プロキシを使用して実際の IP を隠す
   - DDNS サービスを設定 (例: No-IP, DuckDNS)
   - DNS レコードを定期的に更新

#### 構築手順
1. **ハードウェア準備**:
   - GIGABYTE BRIX ミニ準システム
   - Ubuntu Server または CentOS をインストール
   - 静的内網 IP を設定

2. **ソフトウェア環境**:
   - Ruby, Rails, MySQL をインストール
   - Nginx + Passenger を設定
   - ファイアウォールルールを設定

3. **ネットワーク設定**:
   - ルーターポート転送を設定
   - Cloudflare DNS を設定
   - 外部接続をテスト

### 本番環境設定
1. 環境変数を設定
2. Nginx + Passenger を設定
3. MySQL データベースを設定
4. データベースマイグレーションを実行
5. アセットをプリコンパイル

### 推奨 Nginx 設定
```nginx
# HTTP を HTTPS にリダイレクト
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
    listen 8880;  # Cloudflare で使用可能な HTTP
    server_name zz-chan.org www.zz-chan.org;
    return 301 https://$host:8443$request_uri;
}
```

### Cloudflare 設定
1. **DNS 設定**:
   - A レコード: zz-chan.org → XXX.XXX.XXX.XXX (あなたのパブリック IP)
   - プロキシ状態: 有効 (オレンジの雲アイコン)
   - TTL: Auto

2. **SSL/TLS 設定**:
   - 暗号化モード: Full (エンドツーエンド暗号化)
   - エッジ証明書: Cloudflare が自動管理
   - オリジン証明書: Cloudflare Origin CA または自己署名証明書を使用

3. **ルール設定** (Rules → Origin Rules):
   - **ルール 1 - HTTP 書き換え**:
     - 名前: "Http Redirect to 8880"
     - マッチ条件: `Hostname equals zz-chan.org AND SSL/HTTPS does not equal true`
     - アクション: `Rewrite port to 8880`
     - 状態: Active
   
   - **ルール 2 - HTTPS 書き換え**:
     - 名前: "Https Redirect to 8443"
     - マッチ条件: `Hostname equals zz-chan.org AND SSL/HTTPS equals true`
     - アクション: `Rewrite port to 8443`
     - 状態: Active

4. **キャッシュ設定**:
   - キャッシュレベル: Standard
   - ブラウザキャッシュ TTL: 4 時間
   - エッジキャッシュ TTL: 2 時間

### 環境変数設定
```bash
# 本番環境変数
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_LEVEL=info

# データベース設定
DATABASE_URL=mysql2://username:password@localhost/zz_chan_production

# セキュリティ設定
RAILS_MASTER_KEY=your_master_key_here
SECRET_KEY_BASE=your_secret_key_base_here

# URL 設定
RAILS_HOST=zz-chan.org
RAILS_PROTOCOL=https
```

## パフォーマンスとモニタリング

### ハードウェアパフォーマンス
- **CPU 使用率**: 平均 < 30% (Intel Celeron N3350)
- **メモリ使用**: 約 2-3GB (8GB 総容量)
- **ディスク I/O**: SSD が高速読み書きを提供
- **ネットワーク帯域幅**: Gigabit Ethernet が十分な帯域幅を提供

### 家庭用ブロードバンドパフォーマンス考慮事項
- **アップロード帯域幅**: 中華電信家庭用ブロードバンドのアップロードは通常ダウンロードより遅い
- **動的 IP**: 接続の安定性に影響する可能性があり、Cloudflare プロキシの使用を推奨
- **ルーター性能**: H660WM-C の処理能力は限定的で、過度な同時接続を避ける
- **電力消費**: ミニ準システムは低消費電力で、24/7 稼働に適しており、年間電気代は約 67NTD と推定

### アプリケーションパフォーマンス
- **応答時間**: 平均 < 200ms
- **同時処理**: 50+ 同時接続をサポート
- **ファイルアップロード**: 最大 5MB ファイルをサポート
- **データベースクエリ**: インデックスを使用してクエリパフォーマンスを最適化

## 貢献ガイド

1. プロジェクトを Fork
2. 機能ブランチを作成
3. 変更をコミット
4. ブランチにプッシュ
5. Pull Request を作成

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されており、オープンソースでの使用を歓迎します。

### オープンソース声明
- **原作者**: Zan Zas
- **ライセンス方式**: MIT License
- **オープンソース状態**: 完全オープンソース、Fork と貢献を歓迎

### 利用規約
このプロジェクトを使用する際は、以下をお願いします：
1. 元のライセンス声明を保持
2. 適切な場所に原作者 "Zan Zas" を明記
3. 重大な変更を行う場合は、README に変更内容を記載することを推奨

### MIT ライセンス条項
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

## 連絡先

ご質問やご提案がございましたら、GitHub Issues を通じてお問い合わせください。
