class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.float :price
      t.float :sale_price
      t.timestamps
    end
  end
end
