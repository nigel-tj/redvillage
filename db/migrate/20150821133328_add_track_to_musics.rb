class AddTrackToMusics < ActiveRecord::Migration[6.1]
  def change
    add_column :musics, :track, :string
  end
end
