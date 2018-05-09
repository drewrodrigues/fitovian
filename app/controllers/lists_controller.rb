class ListsController < ApplicationController
  before_action :set_resource

  def move_top
    if @resource.move_to_top
      flash[:success] = 'Successfully <b>moved to top</b>'
    else
      flash[:danger] = 'Failed to <b>move to top</b>'
    end
    redirect_back(fallback_location: root_path)
  end

  def move_up
    if @resource.move_higher
      flash[:success] = 'Successfully <b>moved up</b>'
    else
      flash[:danger] = 'Failed to <b>move up</b>'
    end
    redirect_back(fallback_location: root_path)
  end

  def move_bottom
    if @resource.move_to_bottom
      flash[:success] = 'Successfully <b>moved to bottom</b>'
    else
      flash[:danger] = 'Failed to <b>move to bottom</b>'
    end
    redirect_back(fallback_location: root_path)
  end

  def move_down
    if @resource.move_lower
      flash[:success] = 'Successfully <b>moved down</b>'
    else
      flash[:danger] = 'Failed to <b>move down</b>'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_resource
    @resource = params[:type].constantize.find(params[:id])
  end
end
