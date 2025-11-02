class StorePolicy < ApplicationPolicy
  def index?
    true # Anyone can view the list of stores
  end

  def show?
    true # Anyone can view a store
  end

  def create?
    user.present? # Any authenticated user can create a store
  end

  def new?
    create?
  end

  def update?
    user.present? && (user.admin? || record.owner?(user))
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && (user.admin? || record.owner?(user))
  end

  def activate?
    user.present? && user.admin?
  end

  def deactivate?
    user.present? && user.admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user.present?
        # Users can see all active stores and their own stores
        scope.where(active: true).or(scope.where(user_id: user.id))
      else
        # Public users can only see active stores
        scope.where(active: true)
      end
    end
  end
end

