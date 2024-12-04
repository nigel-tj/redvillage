# app/uploaders/sound_uploader.rb
require "shrine"
require "streamio-ffmpeg"

class SoundUploader < Shrine
  plugin :validation_helpers
  plugin :processing
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :default_url

  Attacher.validate do
    validate_max_size 10 * 1024 * 1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion %w[audio/mpeg audio/mp3 audio/wav audio/x-wav audio/ogg audio/x-aiff]
    validate_extension_inclusion %w[mp3 wav ogg aiff]
  end

  process(:store) do |io, context|
    audio = FFMPEG::Movie.new(io.path)
    io.metadata.update(
      duration: audio.duration,
      bitrate: audio.bitrate
    )
    io
  end

  def default_url(*)
    "/audio/fallback/default.mp3"
  end
end
