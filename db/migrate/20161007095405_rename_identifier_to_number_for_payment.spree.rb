# This migration comes from spree (originally 20141218025915)
class RenameIdentifierToNumberForPayment < ActiveRecord::Migration[7.2]
  def change
    rename_column :spree_payments, :identifier, :number
  end
end
