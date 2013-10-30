shared_examples 'access denial' do
  it 'throws 403' do
    expect(response.status).to eq 403
  end
end

shared_examples 'authentication redirector' do |method, action, **args|
  it 'throws uncaught :warden' do
    if args.empty?
      expect{ send(method, action) }.to raise_exception("uncaught throw :warden")
    else
      expect{ send(method, action, args) }.to raise_exception("uncaught throw :warden")
    end
  end
end

shared_context 'project creation' do
  before { post :create, project: valid_attributes }
  let(:project) { Project.last }

  it 'creates project' do
    expect(Project.count).to eq 1
    expect(project.name).to eq valid_attributes['name']
  end

  it 'redirects to project`s show' do
    expect(response).to redirect_to project_path(project)
  end
end

shared_context 'failed project creation' do
  before { post :create, project: invalid_attributes }

  it 'does not create project' do
    expect(Project.count).to eq 0
  end

  it 'returns project errors' do
    expect(assigns(:project).errors).not_to be_empty
  end

  it 'rerenders `new` view' do
    expect(response).to render_template :new
  end
end
