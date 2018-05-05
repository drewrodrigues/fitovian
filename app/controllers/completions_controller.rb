class CompletionsController < ApplicationController
	def create
    completion = Completion.new(
      completable_id: params[:resource_id],
      completable_type: params[:resource_type]
    )
    if current_user.completions << completion
      redirect_to completion.completable, flash: {
        success: "Successfully completed #{completion.completable.title}" 
      }
    else
    end
	end
end
