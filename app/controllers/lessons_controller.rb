class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  # before_action :check_subscription, only: [:index, :show]

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = Lesson.all.sort_by {|l| l.position}
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @lesson, notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to @lesson, notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to panel_path, notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # handle image posts to s3
  def images
    # catch params[:file]
    # respond with json which has the url to the image

    render json: {
      image: { url: 'image_url' }
    }, content_type: 'text/html'
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
end
