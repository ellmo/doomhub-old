module ApplicationHelper

  def backbone_data_hash
    data_hash = { :params => SafeParams.filter_params(params).to_json }
    data_hash.merge!({:debug => 'true'}) if Rails.env.development?
    data_hash
  end

  def user_login_span_tag(user = nil)
    str = "[ "
    if user
      str << "Hello, #{user.login}. | "
      str << link_to("Log out", logout_path)
      str << "]"
    else
      str << link_to("Log in", login_path)
      str << " | "
      str << link_to("Register", register_path)
      str << " ]"
    end
    raw str
  end

end
