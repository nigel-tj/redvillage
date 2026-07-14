class AddTrackToMusics < ActiveRecord::Migration[7.2]
  def change
    add_column :musics, :track, :string
  end
end
