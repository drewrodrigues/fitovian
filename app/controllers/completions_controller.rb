class CompletionsController < ApplicationController
  before_action :onboard_user!
  before_action :set_resource

	def create
    if current_user.complete(@resource)
      redirect_to @resource, flash: {
        success: "Successfully completed <b>#{@resource.title}</b>" 
      }
    end
	end

  def destroy
    if current_user.incomplete(@resource)
      redirect_to @resource, flash: {
        warning: "Successfully marked <b>#{@resource.title}</b> as incomplete"
      }
    end
  end
  
  private
  
  def set_resource
    @resource = params[:resource_type].constantize.find(params[:resource_id])
  end
end
