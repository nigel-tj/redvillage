module ApplicationHelper
  def active_class(path)
    'active' if current_page?(path)
  end
end
