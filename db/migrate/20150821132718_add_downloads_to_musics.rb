class AddDownloadsToMusics < ActiveRecord::Migration[7.2]
class AddDownloadsToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :downloads, :integer
  end
end
