module ApplicationHelper

  include SafeParams

  def backbone_data_hash
    data_hash = { :params => SafeParams.filter_params(params).to_json }
    data_hash.merge!({:debug => 'true'}) if Rails.env.development?
    data_hash
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def user_login_span_tag(user = nil)
    if user
      str = <<-HTML
      <div>
        <span>#{user.login} |<span>
        <span>#{link_to("Log out", destroy_user_session_path, :method => :delete)}</span>
      </div>
      HTML
    else
      str = <<-HTML
      <div>
        <span>#{link_to("Log in", new_user_session_path)}<span> |
        <span>#{link_to("Register", new_user_registration_path)}</span>
      </div>
      HTML
    end
    raw str
  end

end
