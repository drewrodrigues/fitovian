class SelectionsController < ApplicationController
  before_action :onboard_user!
  before_action :set_stack
  before_action :ensure_stack_exists!
  before_action :set_selection, only: :destroy

  def create
    # if a the stack doesn't exist, throw failed message
    # otherwise, add the selection || or if it already exists
    # throw a success message
    selections = current_user.selections
    if selections.create(stack: @stack) || current_user.selected?(@stack)
      flash[:success] = 'Successfully added'
    else
      flash[:danger] = 'Failed to add'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    # if stack doesn't exist, throw failed message
    # when there isn't a selection, just say successful (because that's our fault or the views)
    # if there is, destroy it, then say successful
    if !@selection || @selection.destroy
      flash[:success] = 'Successfully removed'
    else
      flash[:danger] = 'Failed to remove'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def selection_params
    params.permit(:stack_id)
  end

  def set_stack
    @stack = Stack.find_by(id: selection_params[:stack_id])
  end

  def ensure_stack_exists!
    unless @stack
      flash[:danger] = 'Couldn\'t find stack'
      redirect_back(fallback_location: root_path) and return
    end
  end

  def set_selection
    @selection = current_user.selections.find_by(stack: selection_params[:stack_id])
  end
end
