class AddPolymorphicAuthorToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :author_id, :integer
    add_column :maps, :author_type, :string
  end
end
