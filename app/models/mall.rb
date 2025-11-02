class Mall < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history, :finders]
  
  # Associations
  has_many :stores, dependent: :nullify
  
  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  
  # Callbacks
  before_validation :set_default_active, on: :create
  
  # Methods
  def activate!
    update(active: true)
  end
  
  def deactivate!
    update(active: false)
  end
  
  def stores_count
    stores.count
  end
  
  def active_stores_count
    stores.active.count
  end
  
  private
  
  def set_default_active
    self.active = true if active.nil?
  end
  
  # FriendlyId: regenerate slug if name changes
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end

