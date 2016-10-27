class AddHitCounterToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :hit_count, :integer
  end
end
