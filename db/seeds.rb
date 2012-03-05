# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
Game.create(:name => "Doom", :default_lumpname => "E1M1")
Game.create(:name => "Doom 2", :default_lumpname => "MAP01")
Game.create(:name => "Heretic", :default_lumpname => "E1M1")
Game.create(:name => "Hexen", :default_lumpname => "MAP01")
Game.create(:name => "Strife", :default_lumpname => "MAP01")

SourcePort.create(:name => "vanilla")
SourcePort.create(:name => "PRB")
SourcePort.create(:name => "Eternity Engine")
SourcePort.create(:name => "ZDoom")
SourcePort.create(:name => "GZDoom")

UserRole.create(:name => "superadmin")
UserRole.create(:name => "admin")
UserRole.create(:name => "user")
