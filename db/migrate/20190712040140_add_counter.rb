class AddCounter < ActiveRecord::Migration[5.2]
  def change
    add_column :urls, :counter, :integer
  end
end
