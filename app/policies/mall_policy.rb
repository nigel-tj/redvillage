class MallPolicy < ApplicationPolicy
  def index?
    true # Anyone can view the list of malls
  end

  def show?
    true # Anyone can view a mall
  end

  def create?
    user.present? && user.admin? # Only admins can create malls
  end

  def new?
    create?
  end

  def update?
    user.present? && user.admin? # Only admins can update malls
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && user.admin? # Only admins can destroy malls
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        # Public users can only see active malls
        scope.where(active: true)
      end
    end
  end
end

