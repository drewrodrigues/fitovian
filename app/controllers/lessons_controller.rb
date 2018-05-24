class LessonsController < ApplicationController
  before_action :require_admin!, except: :show
  before_action :set_lesson, only: %i[show edit update destroy]
  before_action :set_stack, only: %i[new edit]

  def index
    @lessons = Lesson.all.sort_by(&:position)
  end

  def show
    @stack = @lesson.stack
  end

  def new
    @lesson = Lesson.new
  end

  def edit; end

  def create
    @lesson = Lesson.new(lesson_params)

    if @lesson.save
      redirect_to @lesson, notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson, notice: "Lesson was successfully updated. #{undo_link}"
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to @lesson.stack, notice: "Lesson was successfully destroyed. #{undo_link}"
  end

  # handle image posts to s3
  def images
    # TODO: cleanup
    file = params[:file]
    s3 = Aws::S3::Client.new
    response = s3.put_object(body: file.tempfile, bucket: ENV['S3_BUCKET_NAME'], key: file.original_filename, acl: 'public-read')
    if s3.get_object(bucket: ENV['S3_BUCKET_NAME'], key: file.original_filename) # ensure file persisted
      render json: {
        image: { url: view_context.image_url("https://s3-us-west-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/#{file.original_filename}") }
      }, content_type: 'text/html'
    end
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def set_stack
    @stack = @lesson&.stack || Stack.find(params[:stack_id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :body, :position, :user_id, :stack_id)
  end

  def authenticate_admin!
    redirect_to root_path unless current_user&.admin?
  end

  def check_subscription
    return if current_user.active?
    redirect_to billing_path unless current_user.active?
  end

  def undo_link
    view_context.link_to('Undo', revert_version_path(@lesson.versions.scope.last), method: :post)
  end
end
