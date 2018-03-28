class PagesController < ApplicationController
  layout 'pages'
  skip_before_action :authenticate_user!
  skip_before_action :require_plan!
  

  def landing; end

  def dashboard; end

  def panel
    @lessons = Lesson.all.sort_by(&:position)
  end
end
