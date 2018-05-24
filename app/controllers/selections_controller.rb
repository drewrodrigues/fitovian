class SelectionsController < ApplicationController
  def create
    if SelectionHandler.new(current_user, selection_params[:course_id]).create
      flash[:success] = 'Successfully added'
    else
      flash[:danger] = 'Failed to add'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if SelectionHandler.new(current_user, selection_params[:course_id]).destroy
      flash[:success] = 'Successfully removed'
    else
      flash[:danger] = 'Failed to remove'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def selection_params
    params.permit(:course_id)
  end
end
