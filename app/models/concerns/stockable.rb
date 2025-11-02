module Stockable
  extend ActiveSupport::Concern

  included do
    validates :inventory_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  def in_stock?
    inventory_quantity > 0 && status == 'active'
  end

  def out_of_stock?
    inventory_quantity.zero?
  end

  def low_stock?(threshold = 10)
    inventory_quantity > 0 && inventory_quantity <= threshold
  end

  def available_quantity
    inventory_quantity
  end

  def can_purchase?(quantity = 1)
    in_stock? && available_quantity >= quantity
  end

  def decrease_inventory!(quantity)
    self.inventory_quantity = [0, inventory_quantity - quantity].max
    save!
  end

  def increase_inventory!(quantity)
    self.inventory_quantity += quantity
    save!
  end
end

