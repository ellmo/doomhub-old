attributes :id, :content, :created_at
node (:human_created_at) {|comment| comment.created_at.to_formatted_s(:short) }
child(:user) {
  attributes :login
  node(:owner) { |u| u == current_user }
}