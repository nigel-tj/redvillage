# app/uploaders/image_uploader.rb
require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing
  plugin :versions    # Enable versions for different sizes of images
  plugin :delete_raw  # Delete the original file after processing
  plugin :validation_helpers
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :url_options, store: { host: "http://localhost:3000" }

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    versions = { original: io }

    if io.is_a?(UploadedFile)
      versions.merge! process_versions(io)
    else
      versions.merge! process_versions(io.download)
      io.close! if io.respond_to?(:close!)
    end

    versions
  end

  private

  def process_versions(io)
    magick = ImageProcessing::MiniMagick.source(io)

    {
      large:     magick.resize_to_limit!(800, 800),
      medium:    magick.resize_to_limit!(500, 500),
      thumbnail: magick.resize_to_limit!(300, 300)
    }
  end
end
