class GalleryPolicy < ApplicationPolicy
  def index?
    true # Public browsing
  end

  def show?
    true # Public browsing
  end

  def create?
    # Photographers, curators, editors and admins may create galleries
    user.present? && (user.admin? || user.photographer? || user.curator? || user.editor?)
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope # Galleries are public listings
    end
  end
end
