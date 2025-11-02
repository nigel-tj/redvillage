class ProductImagePolicy < ApplicationPolicy
  def create?
    user.present? && (user.admin? || record.product.store.owner?(user))
  end

  def destroy?
    user.present? && (user.admin? || record.product.store.owner?(user))
  end

  def update_position?
    user.present? && (user.admin? || record.product.store.owner?(user))
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end

