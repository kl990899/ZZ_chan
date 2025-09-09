class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  require 'digest'
  def create
    @discussion_thread = DiscussionThread.find(params[:discussion_thread_id])
    @post = @discussion_thread.posts.new(post_params)

    # 預設匿名名稱
    @post.name = "無名" if @post.name.blank?

    # IP 與雜湊值紀錄
    ip = request.remote_ip
    @post.ip_address = ip
    @post.hashed_ip = Digest::SHA256.hexdigest(ip)[0..7]

    if @post.save
      @discussion_thread.update(updated_at: Time.now)
      redirect_to discussion_thread_path(@discussion_thread), notice: "已成功新增貼文"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:discussion_thread_id, :content, :image, :name)
    end
    
end
