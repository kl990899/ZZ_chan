class DiscussionThreadsController < ApplicationController
  before_action :set_discussion_thread, only: %i[show edit update destroy]

  # GET /discussion_threads or /discussion_threads.json
  def index
    result = DiscussionThread::List.call(params: params)

    if result.success?
      @discussion_threads = result.discussion_threads
      @discussion_thread = DiscussionThread.new
    else
      redirect_to root_path, alert: result.error
    end
  end

  # GET /discussion_threads/1 or /discussion_threads.json
  def show
    result = DiscussionThread::Find.call(id: params[:id])

    if result.success?
      @discussion_thread = result.discussion_thread

      posts_result = Post::List.call(
        discussion_thread_id: @discussion_thread.id,
        params: params
      )

      if posts_result.success?
        @posts = posts_result.posts
        @post = @discussion_thread.posts.new
      else
        redirect_to discussion_threads_path, alert: posts_result.error
      end
    else
      redirect_to discussion_threads_path, alert: result.error
    end
  end

  # GET /discussion_threads/new
  def new
    @discussion_thread = DiscussionThread.new
  end

  # GET /discussion_threads/1/edit
  def edit; end

  # POST /discussion_threads or /discussion_threads.json
  def create
    result = DiscussionThread::Create.call(
      params: params,
      request_ip: request.remote_ip
    )

    if result.success?
      redirect_to discussion_threads_path, notice: '討論串已建立'
    else
      @discussion_threads = DiscussionThread.all.order(created_at: :desc)
      render :index, status: :unprocessable_entity, alert: result.error
    end
  end

  # PATCH/PUT /discussion_threads/1 or /discussion_threads.json
  def update
    result = DiscussionThread::Update.call(
      discussion_thread: @discussion_thread,
      params: params
    )

    respond_to do |format|
      if result.success?
        format.html { redirect_to @discussion_thread, notice: 'Discussion thread was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion_thread }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { error: result.error }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussion_threads/1 or /discussion_threads.json
  def destroy
    result = DiscussionThread::Destroy.call(discussion_thread: @discussion_thread)

    respond_to do |format|
      if result.success?
        format.html do
          redirect_to discussion_threads_path, status: :see_other,
                                               notice: 'Discussion thread was successfully destroyed.'
        end
        format.json { head :no_content }
      else
        format.html { redirect_to discussion_threads_path, alert: result.error }
        format.json { render json: { error: result.error }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discussion_thread
    result = DiscussionThread::Find.call(id: params[:id])

    if result.success?
      @discussion_thread = result.discussion_thread
    else
      redirect_to discussion_threads_path, alert: result.error
    end
  end
end
