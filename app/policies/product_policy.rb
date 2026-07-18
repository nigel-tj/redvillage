class ProductPolicy < ApplicationPolicy
  def index?
    true # Anyone can view products
  end

  def show?
    true # Anyone can view a product
  end

  def create?
    user.present? && (user.admin? || record.store.owner?(user))
  end

  def new?
    create?
  end

  def update?
    user.present? && (user.admin? || record.store.owner?(user))
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && (user.admin? || record.store.owner?(user))
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user.present?
        owned_store_ids = Store.where(user_id: user.id).select(:id)
        scope.where(status: "active").or(scope.where(store_id: owned_store_ids))
      else
        scope.where(status: "active")
      end
    end
  end
end

