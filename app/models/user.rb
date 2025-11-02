class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum :role, { member: 0, admin: 1 }

  validates :name, presence: true, length: { maximum: 100 }
  validates :role, presence: true

  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role = :member if role.blank?
  end
end
