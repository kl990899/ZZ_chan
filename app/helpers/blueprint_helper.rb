require 'blueprinter'

module BlueprintHelper
  def serialize_with_blueprint(object, blueprint_class, view: :default)
    return nil if object.nil?

    if object.is_a?(Array) || object.is_a?(ActiveRecord::Relation)
      object.map { |item| blueprint_class.render(item, view: view) }
    else
      blueprint_class.render(object, view: view)
    end
  end

  def discussion_thread_data(discussion_thread, view: :show)
    DiscussionThread::InfoBlueprint.render_as_hash(discussion_thread, view: view)
  end

  def post_data(post, view: :show)
    Post::InfoBlueprint.render_as_hash(post, view: view)
  end

  def posts_data(posts, view: :list)
    serialize_with_blueprint(posts, Post::InfoBlueprint, view: view)
  end
end
