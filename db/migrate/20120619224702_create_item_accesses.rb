class CreateItemAccesses < ActiveRecord::Migration
  def change
    create_table :item_accesses do |t|
      t.string :name

      t.timestamps
    end
  end
end
