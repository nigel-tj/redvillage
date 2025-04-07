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
    validate_max_size 5 * 1024 * 1024 # 5MB
  end

  process(:store) do |io, context|
    versions = { original: io }

    io_path = io.download.path if io.respond_to?(:download)
    io_path ||= io.path if io.respond_to?(:path)

    if io_path
      versions.merge! process_versions(io_path)
    end

    versions
  end

  private

  def process_versions(io_path)
    magick = ImageProcessing::MiniMagick.source(io_path)

    {
      large:     magick.resize_to_limit!(800, 800),
      medium:    magick.resize_to_limit!(500, 500),
      thumbnail: magick.resize_to_limit!(300, 300)
    }
  rescue => e
    Rails.logger.error "Error processing image: #{e.message}"
    { large: io_path, medium: io_path, thumbnail: io_path }
  end
end
