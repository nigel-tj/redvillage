require "shrine"
require "shrine/storage/file_system"
require "fileutils"

# Ensure the upload directories exist
FileUtils.mkdir_p("public/uploads/cache")
FileUtils.mkdir_p("public/uploads/store")

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
}

Shrine.plugin :activerecord           # for Active Record integration
Shrine.plugin :cached_attachment_data # retain cached file across form redisplays
Shrine.plugin :restore_cached_data    # refresh metadata for cached files
Shrine.plugin :determine_mime_type    # determine MIME type from file content
Shrine.plugin :store_dimensions       # store image dimensions
Shrine.plugin :validation_helpers     # for file validation
Shrine.plugin :processing             # for image processing
Shrine.plugin :versions               # for image versions
Shrine.plugin :upload_options         # for upload options
Shrine.plugin :pretty_location        # for organized folder structure
Shrine.plugin :tempfile               # for using temfiles
