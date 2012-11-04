attributes :id, :created_at, :bumped
node (:human_created_at) {|comment| comment.created_at.to_formatted_s(:short) }
node (:human_updated_at) {|comment| comment.updated_at.to_formatted_s(:short) }
node (:path) {|comment| comment.path }
node (:content) {|comment| MD.render(comment.content) }
node (:raw_content) {|comment| comment.content }
node (:edited) {|comment| comment.edited? }
node (:edited_by) {|comment| comment.last_edit_author }
child(:user) {
  attributes :login
  node(:owner) { |u| current_user.admin? or u == current_user }
}