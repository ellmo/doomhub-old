attributes :id, :created_at
node (:human_created_at) {|comment| comment.created_at.to_formatted_s(:short) }
node (:path) {|comment| comment.path }
node (:content) {|comment| MD.render(comment.content) }
child(:user) {
  attributes :login
  node(:owner) { |u| u == current_user }
}