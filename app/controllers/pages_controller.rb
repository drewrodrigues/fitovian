class PagesController < ApplicationController
  layout 'pages'
  skip_before_action :authenticate_user!
  skip_before_action :require_plan!
  skip_before_action :require_payment_method!

  def landing; end

  def dashboard; end

  def panel
    @lessons = Lesson.all.sort_by(&:position)
  end
end
