class SelectionHandler
  def initialize(user, course_id)
    @user = user
    @course = Course.find_by(id: course_id)
  end

  def create
    return false unless @course
    Selection.create(course: @course, user: @user)
  end

  def destroy
    return false unless @course
    Selection.find_by(course: @course)&.destroy
  end
end
