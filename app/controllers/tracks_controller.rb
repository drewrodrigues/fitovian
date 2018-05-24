class TracksController < ApplicationController
  before_action :set_track, only: %i[show edit update destroy select]
  before_action :set_course_track, only: %i[new edit]

  def index
    @tracks = Track.order(:title).all
  end

  def show; end

  def new
    @track = Track.new
  end

  def edit; end

  def create
    @track = Track.new(track_params)

    if @track.save
      redirect_to @track, notice: 'Track was successfully created.'
    else
      render :new
    end
  end

  def update
    if @track.update(track_params)
      redirect_to @track, notice: 'Track was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @track.destroy
    redirect_to tracks_url, notice: 'Track was successfully destroyed.'
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

  def set_track
    @track = Track.find(params[:id])
  end

  def set_course_track
    @course = CourseTrack.new(track: @track)
  end

  def track_params
    params.require(:track).permit(:title, :icon)
  end
end
