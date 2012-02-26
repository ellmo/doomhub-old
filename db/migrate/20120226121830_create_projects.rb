class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :name, :unique => true, :null => false
      t.string  :url_name, :null => false
      t.string  :slug, :null => false
      t.text    :description
      t.integer :game_id, :null => false
      t.integer :source_port_id, :null => false

      t.timestamps
    end

    add_index :projects, :slug, :unique => true
  end
end
