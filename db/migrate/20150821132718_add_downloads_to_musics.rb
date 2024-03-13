class AddDownloadsToMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :downloads, :integer
  end
end
