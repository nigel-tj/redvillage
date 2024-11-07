# This migration comes from spree (originally 20150122202432)
class AddCodeToSpreePromotionCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_promotion_categories, :code, :string
  end
end
