class AddSummaryToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :summary, :text
  end
end
