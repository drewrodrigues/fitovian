module CategoriesHelper
  def library_intro_path
    'library_intro'
  end

  def the_journey_path
    Stack.where(title: 'The Journey').first
  end

  def admin_buttons_path(category)
    render partial: 'admin_buttons', locals: { category: category } if current_user&.admin?
  end
end
