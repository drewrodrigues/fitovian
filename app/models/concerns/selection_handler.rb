class SelectionHandler
  def initialize(user, stack_id)
    @user = user
    @stack = Stack.find_by(id: stack_id)
  end

  def create
    return false unless @stack
    Selection.create(stack: @stack, user: @user)
  end

  def destroy
    return false unless @stack
    Selection.find_by(stack: @stack)&.destroy
  end
end
