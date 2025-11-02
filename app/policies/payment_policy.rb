class PaymentPolicy < ApplicationPolicy
  def new?
    user.present? && (record.order.user == user || user.admin? || record.order.store.owner?(user))
  end

  def create?
    new?
  end

  def confirm?
    new?
  end

  def show?
    user.present? && (record.order.user == user || user.admin? || record.order.store.owner?(user))
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user.present?
        scope.joins(:order).where(
          orders: { user_id: user.id }
        ).or(
          scope.joins(:order => :store).where(stores: { user_id: user.id })
        )
      else
        scope.none
      end
    end
  end
end

