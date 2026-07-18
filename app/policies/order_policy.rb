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
        owned_store_ids = Store.where(user_id: user.id).select(:id)
        scope.where(user_id: user.id).or(scope.where(store_id: owned_store_ids))
      else
        scope.none
      end
    end
  end
end

