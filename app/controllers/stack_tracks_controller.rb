class CourseTracksController < ApplicationController
  before_action :set_course_track, only: %i[show edit update destroy]

  def index
    @course_tracks = CourseTrack.all
  end

  def show; end

  def new
    @course_track = CourseTrack.new
  end

  def edit; end

  def create
    @course_track = CourseTrack.new(course_track_params)

    if @course_track.save
      redirect_to @course_track.track, notice: 'course track was successfully created.'
    else
      render :new
    end
  end

  def update
    if @course_track.update(course_track_params)
      redirect_to @course_track, notice: 'course track was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @course_track.destroy
    redirect_to course_tracks_url, notice: 'course track was successfully destroyed.'
  end

  private

  def set_course_track
    @course_track = CourseTrack.find(params[:id])
  end

  def course_track_params
    params.require(:course_track).permit(:track_id, :course_id)
  end
end
