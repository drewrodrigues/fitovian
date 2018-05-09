class TracksController < ApplicationController
  before_action :set_track, only: %i[show edit update destroy select]
  before_action :set_stack_track, only: %i[new edit]

  # GET /tracks
  # GET /tracks.json
  def index
    @tracks = Track.order(:title).all
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show; end

  # GET /tracks/new
  def new
    @track = Track.new
  end

  # GET /tracks/1/edit
  def edit; end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(track_params)

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render :show, status: :created, location: @track }
      else
        format.html { render :new }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracks/1
  # PATCH/PUT /tracks/1.json
  def update
    respond_to do |format|
      if @track.update(track_params)
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { render :show, status: :ok, location: @track }
      else
        format.html { render :edit }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track.destroy
    respond_to do |format|
      format.html { redirect_to tracks_url, notice: 'Track was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def select
    current_user.track = @track
    if current_user.save
      redirect_to @track, flash: { success: "#{@track.title} track selected." }
    else
      redirect_to tracks_path, flash: { alert: "#{@track.title} not selected." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_track
    @track = Track.find(params[:id])
  end

  def set_stack_track
    @stack_track = StackTrack.new(track: @track)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def track_params
    params.require(:track).permit(:title, :icon)
  end
end
