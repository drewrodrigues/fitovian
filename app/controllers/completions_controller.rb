class CompletionsController < ApplicationController
  before_action :set_resource

  def create
    message = if CompletionHandler.complete(current_user, @resource)
                { success: "Successfully completed <b>#{@resource.title}</b>" }
              else
                { danger: 'Failed to complete' }
              end
    redirect_to @resource, flash: message
  end

  def destroy
    message = if CompletionHandler.incomplete(current_user, @resource)
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
