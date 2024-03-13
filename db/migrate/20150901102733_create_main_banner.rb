class CreateMainBanner < ActiveRecord::Migration[6.1]
  def change
    create_table :main_banners do |t|
      t.string :name
      t.string :image
      t.string :title
    end
  end
end
