class PagesController < ApplicationController
  layout 'pages'
  
  def landing
  end

  def dashboard
  end

  def panel
    @lessons = Lesson.all.sort_by {|l| l.position }
  end

  def about
  end

  def get_started
  end

  def services
  end

  def choose_us
  end

  def rates
  end

  def our_program
  end
end
