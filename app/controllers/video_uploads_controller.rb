class VideoUploadsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin", only: [:new, :create, :update]

  def new
    @video_upload = VideoUpload.new
  end

  def create
    video_upload_params = params.require(:video_upload).permit(:title, :description, :file)
    @video_upload = VideoUpload.new(title: video_upload_params[:title],
                                    description: video_upload_params[:description],
                                    file: video_upload_params[:file].try(:tempfile).try(:to_path))
    if @video_upload.save
      uploaded_video = @video_upload.upload!(current_admin)

      if uploaded_video.failed?
        flash[:error] = 'There was an error while uploading your video...'
      else
        Video.create({link: "https://www.youtube.com/watch?v=#{uploaded_video.id}"})
        flash[:success] = 'Your video has been uploaded!'
      end
      redirect_to root_url
    else
      render :new
    end
  end
end
