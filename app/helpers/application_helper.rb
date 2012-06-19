module ApplicationHelper

  include SafeParams

  def backbone_data_hash
    data_hash = { :params => SafeParams.filter_params(params).to_json }
    data_hash.merge!({:debug => 'true'}) if Rails.env.development?
    data_hash
  end

  def user_login_span_tag(user = nil)
    if user
      str = <<-HTML
      <div>
        <span>#{user.login} |<span>
        <span>#{link_to("Log out", logout_path)}</span>
      </div>
      HTML
    else
      str = <<-HTML
      <div>
        <span>#{link_to("Log in", login_path)}<span> |
        <span>#{link_to("Register", register_path)}</span>
      </div>
      HTML
    end
    raw str
  end

end
