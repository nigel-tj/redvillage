class Ad < ActiveRecord::Base
  include ImageUploader::Attachment(:image)
  
  belongs_to :ad_spot
  
  validates :title, presence: true
  validates :ad_spot_id, presence: true
  validates :url, format: { with: /\A#{URI::regexp(['http', 'https'])}\z/, message: "must be a valid URL" }, allow_blank: true
  validates :advertiser_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :end_date_after_start_date
  
  scope :active, -> { where(active: true) }
  scope :current, -> { where('(start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date >= ?)', Date.current, Date.current) }
  scope :active_current, -> { active.current }
  
  def click!
    increment!(:clicks)
  end
  
  def impression!
    increment!(:impressions)
  end
  
  def click_through_rate
    return 0.0 if impressions.zero?
    (clicks.to_f / impressions * 100).round(2)
  end
  
  def currently_active?
    active? && 
      (start_date.nil? || start_date <= Date.current) &&
      (end_date.nil? || end_date >= Date.current)
  end
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end

