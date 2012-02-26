class CreateSourcePorts < ActiveRecord::Migration
  def change
    create_table :source_ports do |t|
      t.string :name

      t.timestamps
    end
  end
end
