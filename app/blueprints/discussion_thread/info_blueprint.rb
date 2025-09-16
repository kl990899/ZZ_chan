require 'blueprinter'

class DiscussionThread::InfoBlueprint < Blueprinter::Base
  identifier :id

  fields :name,
         :title

  field :created_at do |discussion_thread|
    discussion_thread.created_at.strftime('%Y/%m/%d(%a) %H:%M:%S')
  end

  field :updated_at do |discussion_thread|
    discussion_thread.updated_at.strftime('%Y/%m/%d(%a) %H:%M:%S')
  end

  field :hash_ip do |discussion_thread|
    # 從第一個 post 取得 hashed_ip
    first_post = discussion_thread.posts.order(:created_at).first
    first_post&.hashed_ip
  end

  field :posts_count do |discussion_thread|
    discussion_thread.posts.count
  end

  view :show do
    # 使用頂層已定義的欄位，無需重複定義
  end

  view :with_posts do
    # 使用頂層已定義的欄位，無需重複定義
    association :posts, blueprint: Post::InfoBlueprint, view: :list
  end
end
