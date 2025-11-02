class AddTicketPricesToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :standard_ticket_price, :decimal, precision: 10, scale: 2
    add_column :events, :vip_ticket_price, :decimal, precision: 10, scale: 2
  end
end
