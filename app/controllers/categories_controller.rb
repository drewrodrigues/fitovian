class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :require_admin!, except: :index

  def index
    @categories = Category.includes(:courses).all
    @selections = current_user.selections.pluck(:course_id)
    @category = Category.new
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to library_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      format.html {
        redirect_to library_path, notice: "Category was successfully updated. #{undo_link}"
      }
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to library_path, notice: "Category was successfully destroyed. #{undo_link}"
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :color)
  end

  def undo_link
    view_context.link_to('Undo', revert_version_path(@category.versions.scope.last), method: :post)
  end
end
