class User < ActiveRecord::Base
  include Profileable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum :role, { 
    member: 0, 
    admin: 1, 
    dj: 2, 
    artist: 3,
    photographer: 4,
    videographer: 5,
    curator: 6,
    designer: 7,
    editor: 8
  }

  validates :name, presence: true, length: { maximum: 100 }
  validates :role, presence: true

  before_validation :set_default_role, on: :create

  # Scopes for role-based queries
  scope :djs, -> { where(role: :dj) }
  scope :artists, -> { where(role: :artist) }
  scope :photographers, -> { where(role: :photographer) }
  scope :videographers, -> { where(role: :videographer) }
  scope :curators, -> { where(role: :curator) }
  scope :designers, -> { where(role: :designer) }
  scope :editors, -> { where(role: :editor) }
  scope :content_creators, -> { where(role: [:dj, :artist, :photographer, :videographer, :curator, :designer, :editor]) }
  scope :backstage_users, -> { where(role: [:dj, :artist, :photographer, :videographer, :curator, :designer, :editor, :admin]) }

  # Helper methods for role checks
  def backstage_user?
    dj? || artist? || photographer? || videographer? || curator? || designer? || editor? || admin?
  end

  def can_access_backend?
    backstage_user?
  end

  def content_creator?
    photographer? || videographer? || curator? || designer? || editor? || artist? || dj?
  end

  private

  def set_default_role
    self.role = :member if role.blank?
  end
end
