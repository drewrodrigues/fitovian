class StackTracksController < ApplicationController
  before_action :set_stack_track, only: [:show, :edit, :update, :destroy]

  # GET /stack_tracks
  # GET /stack_tracks.json
  def index
    @stack_tracks = StackTrack.all
  end

  # GET /stack_tracks/1
  # GET /stack_tracks/1.json
  def show
  end

  # GET /stack_tracks/new
  def new
    @stack_track = StackTrack.new
  end

  # GET /stack_tracks/1/edit
  def edit
  end

  # POST /stack_tracks
  # POST /stack_tracks.json
  def create
    @stack_track = StackTrack.new(stack_track_params)

    respond_to do |format|
      if @stack_track.save
        format.html { redirect_to @stack_track, notice: 'Stack track was successfully created.' }
        format.json { render :show, status: :created, location: @stack_track }
      else
        format.html { render :new }
        format.json { render json: @stack_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stack_tracks/1
  # PATCH/PUT /stack_tracks/1.json
  def update
    respond_to do |format|
      if @stack_track.update(stack_track_params)
        format.html { redirect_to @stack_track, notice: 'Stack track was successfully updated.' }
        format.json { render :show, status: :ok, location: @stack_track }
      else
        format.html { render :edit }
        format.json { render json: @stack_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stack_tracks/1
  # DELETE /stack_tracks/1.json
  def destroy
    @stack_track.destroy
    respond_to do |format|
      format.html { redirect_to stack_tracks_url, notice: 'Stack track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stack_track
      @stack_track = StackTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stack_track_params
      params.require(:stack_track).permit(:track_id, :stack_id)
    end
end
