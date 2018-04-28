class StacksController < ApplicationController
  before_action :set_stack, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: :show

  # GET /stacks/1
  # GET /stacks/1.json
  def show
  end

  # GET /stacks/new
  def new
    @stack = Stack.new
  end

  # GET /stacks/1/edit
  def edit
  end

  # POST /stacks
  # POST /stacks.json
  def create
    @stack = Stack.new(stack_params)

    respond_to do |format|
      if @stack.save
        format.html { redirect_to @stack, notice: 'Stack was successfully created.' }
        format.json { render :show, status: :created, location: @stack }
      else
        format.html { render :new }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stacks/1
  # PATCH/PUT /stacks/1.json
  def update
    respond_to do |format|
      if @stack.update(stack_params)
        undo_link = view_context.link_to('Undo', revert_version_path(@stack.versions.last), method: :post)
        format.html { redirect_to @stack, notice: "Stack was successfully updated. #{undo_link}" }
        format.json { render :show, status: :ok, location: @stack }
      else
        format.html { render :edit }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stacks/1
  # DELETE /stacks/1.json
  def destroy
    @stack.destroy
    respond_to do |format|
      format.html { redirect_to library_path, notice: 'Stack was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stack
      @stack = Stack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stack_params
      params.require(:stack).permit(:title, :category_id, :icon, :color)
    end
end
