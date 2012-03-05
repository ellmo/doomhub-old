class AddDefaultLumpnameToGames < ActiveRecord::Migration
  def change
    add_column :games, :default_lumpname, :string
  end
end
