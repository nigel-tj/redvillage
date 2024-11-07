# This migration comes from spree (originally 20121111231553)
class RemoveDisplayOnFromPaymentMethods < ActiveRecord::Migration[7.2]
  def up
    remove_column :spree_payment_methods, :display_on
  end
end
