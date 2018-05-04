module CategoriesHelper
  def library_intro_path
    if current_user
      'the_journey'
    else
      'library_intro'
    end
  end

  def the_journey_path
    Stack.where(title: 'The Journey').first
  end
end
