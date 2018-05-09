class CompletionsController < ApplicationController
  before_action :onboard_user!
  before_action :set_resource

  def create
    message = if current_user.complete(@resource)
                { success: "Successfully completed <b>#{@resource.title}</b>" }
              else
                { danger: 'Failed to complete' }
              end
    redirect_to @resource, flash: message
  end

  def destroy
    message = if current_user.incomplete(@resource)
                { warning: "Successfully marked <b>#{@resource.title}</b> as incomplete" }
              else
                { danger: 'Failed to mark incomplete' }
              end
    redirect_to @resource, flash: message
  end

  private

  def set_resource
    @resource = params[:resource_type].constantize.find(params[:resource_id])
  end
end
