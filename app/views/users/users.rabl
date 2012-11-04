attributes :login, :banned
node (:role) {|user| user.role.name }
node (:deleted) {|user| !!user.deleted_at }