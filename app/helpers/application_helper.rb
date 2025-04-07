module ApplicationHelper
  def active_class(path)
    'active' if current_page?(path)
  end
  
  # Helper to get the image URL from a Shrine attachment
  def shrine_image_url(record, field, version = nil)
    return nil unless record && record.send(field)
    
    if version && record.send(field)[version]
      "/uploads/store/#{record.send(field)[version]['id']}"
    elsif record.send(field)['id']
      "/uploads/store/#{record.send(field)['id']}" 
    else
      nil
    end
  end
end
