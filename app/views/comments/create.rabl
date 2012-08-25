collection @comments
attributes :content, :created_at
child(:user) { attributes :login }