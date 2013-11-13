attributes :id, :created_at, :bumped
node(:owner) { |comment| current_user and (current_user.admin? or comment.user == current_user) }
node(:human_created_at) {|comment| comment.created_at.to_formatted_s(:short) }
node(:human_updated_at) {|comment| comment.updated_at.to_formatted_s(:short) }
node(:path) {|comment| comment.path }
node(:content) {|comment| MD.render(comment.content) }
node(:raw_content) {|comment| comment.content }
node(:user) {|comment| partial "users/users", :object => comment.user }
node(:edited) {|comment| comment.edited? }
node(:edited_by) {|comment| partial "users/users", :object => comment.last_edit_author }
