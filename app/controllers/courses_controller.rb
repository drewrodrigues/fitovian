class CoursesController < ApplicationController
  before_action :require_admin!, except: %i[show begin]
  before_action :set_course, only: %i[show edit update destroy begin]
  before_action :set_category, only: %i[new edit]

  def show; end

  def new
    @course = Course.new
  end

  def edit; end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated. #{undo_link}"
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to library_path, notice: "Course was successfully destroyed. #{undo_link}"
  end

  def begin
    SelectionHandler.new(current_user, params[:id]).create
    redirect_to @course.lessons&.first || @course
  end

  private

  def set_course
    @course = Course.includes(:category).find(params[:id])
  end

  def set_category
    @category = @course&.category || Category.find(params[:category_id])
  end

  def course_params
    params.require(:course).permit(:title, :category_id, :icon, :color, :summary)
  end

  def undo_link
    view_context.link_to('Undo', revert_version_path(@course.versions.scope.last), method: :post)
  end
end
