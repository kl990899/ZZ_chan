class DiscussionThreadsController < ApplicationController
  before_action :set_discussion_thread, only: %i[ show edit update destroy ]

  # GET /discussion_threads or /discussion_threads.json
  def index
    @discussion_threads = DiscussionThread.all.order(updated_at: :desc).page(params[:page]).per(12)
    @discussion_thread = DiscussionThread.new
  end

  # GET /discussion_threads/1 or /discussion_threads/1.json
  def show
    @discussion_thread = DiscussionThread.find(params[:id])
    @posts = @discussion_thread.posts.order(created_at: :desc).page(params[:page]).per(12)
    @post = @discussion_thread.posts.new
  end 

  # GET /discussion_threads/new
  def new
    @discussion_thread = DiscussionThread.new
  end

  # GET /discussion_threads/1/edit
  def edit
  end

  # POST /discussion_threads or /discussion_threads.json
  def create
    thread_name = params[:name].presence || "匿名"
    thread_title = params[:title].presence || "無題"
    thread_ip = request.remote_ip
    thread_hash_ip = Digest::SHA256.hexdigest(thread_ip)[0, 8]
  
    @discussion_thread = DiscussionThread.new(
      name: thread_name,
      title: thread_title
    )

    post = @discussion_thread.posts.build(
      name: @discussion_thread.name,
      content: params[:content],
      ip_address: thread_ip,
      hashed_ip: thread_hash_ip
    )

    # 自動分類檔案類型
    auto_classify_uploaded_file(post)

    if @discussion_thread.save
      redirect_to discussion_threads_path, notice: "討論串已建立"
    else
      @discussion_threads = DiscussionThread.all.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /discussion_threads/1 or /discussion_threads/1.json
  def update
    respond_to do |format|
      if @discussion_thread.update(discussion_thread_params)
        format.html { redirect_to @discussion_thread, notice: "Discussion thread was successfully updated." }
        format.json { render :show, status: :ok, location: @discussion_thread }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @discussion_thread.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_threads/1 or /discussion_threads/1.json
  def destroy
    @discussion_thread.destroy!

    respond_to do |format|
      format.html { redirect_to discussion_threads_path, status: :see_other, notice: "Discussion thread was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion_thread
      @discussion_thread = DiscussionThread.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def discussion_thread_params
      params.require(:discussion_thread).permit(:title, :name, :content, :image, :video)
    end
    
    # 自動分類上傳的檔案
    def auto_classify_uploaded_file(post)
      return unless params[:file].present?
      
      uploaded_file = params[:file]
      content_type = uploaded_file.content_type
      
      if image_content_type?(content_type)
        post.image.attach(uploaded_file)
      elsif video_content_type?(content_type)
        post.video.attach(uploaded_file)
      else
        post.errors.add(:file, "不支援的檔案類型，只支援圖片 (JPEG, JPG, PNG, GIF, WebP) 或影片 (MP4, WebM) 格式")
      end
    end
    
    # 檢查是否為圖片類型
    def image_content_type?(content_type)
      content_type.in?(%w[image/jpg image/jpeg image/png image/gif image/webp])
    end
    
    # 檢查是否為影片類型
    def video_content_type?(content_type)
      content_type.in?(%w[video/mp4 video/webm])
    end
end