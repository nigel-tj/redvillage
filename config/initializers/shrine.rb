require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
}

Shrine.plugin :activerecord    # for Active Record integration
Shrine.plugin :cached_attachment_data # retain cached file across form redisplays
Shrine.plugin :restore_cached_data    # refresh metadata for cached files
