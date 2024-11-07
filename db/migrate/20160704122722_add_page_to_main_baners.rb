class AddPageToMainBaners < ActiveRecord::Migration[7.2]
  def change
    add_column :main_banners, :page, :string
  end
end
