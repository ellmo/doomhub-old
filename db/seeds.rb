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

ItemAccess.create(:name => 'Public')
ItemAccess.create(:name => 'Closed')
ItemAccess.create(:name => 'Private')