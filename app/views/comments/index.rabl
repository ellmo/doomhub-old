collection @comments
attributes :content, :created_at
child(:user) {
  attributes :login
  node(:owner) { |u| u == current_user }
}