class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.integer :authorable_id
      t.string :authorable_type

      t.timestamps
    end
  end
end
