class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.page(params[:page]).per(12)
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    result = Post::Create.call(
      params: params,
      request_ip: request.remote_ip
    )

    if result.success?
      @discussion_thread = result.post.discussion_thread
      @discussion_thread.update(updated_at: Time.now)
      redirect_to discussion_thread_path(@discussion_thread), notice: '已成功新增貼文'
    else
      @discussion_thread = DiscussionThread.find(params[:discussion_thread_id])
      @post = @discussion_thread.posts.new
      render :new, status: :unprocessable_entity, alert: result.error
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    result = Post::Update.call(
      post: @post,
      params: params
    )

    respond_to do |format|
      if result.success?
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { error: result.error }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    result = Post::Destroy.call(post: @post)

    respond_to do |format|
      if result.success?
        format.html { redirect_to posts_path, status: :see_other, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to posts_path, alert: result.error }
        format.json { render json: { error: result.error }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    result = Post::Find.call(id: params[:id])

    if result.success?
      @post = result.post
    else
      redirect_to posts_path, alert: result.error
    end
  end
end
