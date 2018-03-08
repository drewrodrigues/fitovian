class PagesController < ApplicationController
  layout 'pages'

  def landing; end

  def dashboard; end

  def panel
    @lessons = Lesson.all.sort_by(&:position)
  end
end
