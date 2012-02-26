require 'spec_helper'

describe "projects/new.html.haml" do
  before(:each) do
    assign(:project, stub_model(Project,
      :name => "MyString",
      :url_name => "MyString",
      :description => "MyText",
      :game_id => 1,
      :source_port_id => 1
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path, :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_url_name", :name => "project[url_name]"
      assert_select "textarea#project_description", :name => "project[description]"
      assert_select "input#project_game_id", :name => "project[game_id]"
      assert_select "input#project_source_port_id", :name => "project[source_port_id]"
    end
  end
end
