class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :link
      t.string :generated_link
      t.integer :user_id
      t.timestamps
    end
  end
end
