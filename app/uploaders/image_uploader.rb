# app/uploaders/image_uploader.rb
require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing
  plugin :versions    # Enable versions for different sizes of images
  plugin :delete_raw  # Delete the original file after processing
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    original = io.download

    pipeline = ImageProcessing::MiniMagick.source(original)
    size_800 = pipeline.resize_to_limit!(800, 800)
    size_500 = pipeline.resize_to_limit!(500, 500)
    size_300 = pipeline.resize_to_limit!(300, 300)

    original.close!

    { original: io, large: size_800, medium: size_500, thumbnail: size_300 }
  end
end
