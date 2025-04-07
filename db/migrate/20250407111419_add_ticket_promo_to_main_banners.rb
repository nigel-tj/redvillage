class AddTicketPromoToMainBanners < ActiveRecord::Migration[7.2]
  def change
    add_column :main_banners, :ticket_promo, :boolean
  end
end
