# This migration comes from spree (originally 20130413230529)
class AddNameToSpreeCreditCards < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_credit_cards, :name, :string
  end
end
