class DiscussionThreadsController < ApplicationController
  before_action :set_discussion_thread, only: %i[ show edit update destroy ]

  # GET /discussion_threads or /discussion_threads.json
  def index
    @discussion_threads = DiscussionThread.all.order(updated_at: :desc)
    @discussion_thread = DiscussionThread.new
  end

  # GET /discussion_threads/1 or /discussion_threads/1.json
  def show
    @discussion_thread = DiscussionThread.find(params[:id])
    @posts = @discussion_thread.posts.order(created_at: :desc)
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
      hashed_ip: thread_hash_ip,
      image: params[:image]
    )

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
      params.require(:discussion_thread).permit(:title, :name, :content, :image)
    end
end