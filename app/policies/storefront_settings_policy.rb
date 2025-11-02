class StorefrontSettingsPolicy < ApplicationPolicy
  def show?
    true # Anyone can view storefront settings (public)
  end

  def edit?
    user.present? && (user.admin? || record.store.owner?(user))
  end

  def update?
    edit?
  end

  def preview?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.all # Storefront settings are public
    end
  end
end

