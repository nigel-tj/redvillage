class CreateEmails < ActiveRecord::Migration[7.2]
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.text :subject
      t.string :body

      t.timestamps null: false
    end
  end
end
