class Event < ActiveRecord::Base
  has_many :standard_tickets
  has_many :vip_tickets
  has_many :users
  include ImageUploader::Attachment(:image)

  def formatted_start_time
    return "TBA" if start_time.blank?
    
    begin
      # Try to parse the time string
      time = Time.parse(start_time)
      time.strftime("%l:%M %p")
    rescue ArgumentError
      # If parsing fails, return the original string
      start_time
    end
  end
end
