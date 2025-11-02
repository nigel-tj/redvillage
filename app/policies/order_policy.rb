class OrderPolicy < ApplicationPolicy
  def index?
    user.present? # Must be authenticated
  end

  def show?
    user.present? && (user.admin? || record.store.owner?(user) || record.user == user)
  end

  def create?
    user.present? # Any authenticated user can create orders
  end

  def update?
    user.present? && (user.admin? || record.store.owner?(user))
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user.present?
        # Users can see their own orders and orders for their stores
        scope.where(user_id: user.id).or(
          scope.joins(:store).where(stores: { user_id: user.id })
        )
      else
        scope.none
      end
    end
  end
end

