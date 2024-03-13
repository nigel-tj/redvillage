class AddSummaryToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :summary, :text
  end
end
