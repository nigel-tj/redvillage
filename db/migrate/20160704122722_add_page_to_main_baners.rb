class AddPageToMainBaners < ActiveRecord::Migration[6.1]
  def change
    add_column :main_banners, :page, :string
  end
end
