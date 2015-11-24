ActiveAdmin.register Sprint do
  permit_params :title, :started_at, :finished_at, :state

  # Index page
  index do
    column :id
    column 'title' do |sprint|
      link_to sprint.title, admin_sprint_path(sprint)
    end
    column 'state' do |sprint|
      _states = { 'pending' => :yes, 'started' => :ok, 'closed' => :no }
      status_tag sprint.state, _states[sprint.state]
    end
    column :started_at
    column :finished_at
    actions
    column 'Report' do |sprint|
      link_to 'Report', { id: sprint.id, action: 'report' }, method: :get
    end
  end

  # Scopes
  scope :all, default: true
  scope('Pending') { |sprints| sprints.where(state: 'pending') }
  scope('Started') { |sprints| sprints.where(state: 'started') }
  scope('Closed') { |sprints| sprints.where(state: 'closed') }

  # Show page
  show do
    panel 'Sprint Details' do
      attributes_table_for sprint do
        row('Status') do
          _states = { 'pending' => :yes, 'started' => :ok, 'closed' => :no }
          status_tag sprint.state, _states[sprint.state]
        end
        row('started_at') { sprint.started_at }
        row('finished_at') { sprint.finished_at }
        row('Report') do
          link_to 'Report', { id: sprint.id, action: 'report' }, method: :get
        end
      end
    end

    active_admin_comments
  end

  # Show all users who dont have rations in sprint
  sidebar 'Haven\'t ordered yet', only: :show do
    table_for Person.without_rations_for(sprint.id) do
      column 'Name' do |person|
        link_to person.name, admin_person_path(person)
      end
      column 'Email' do |person|
        link_to person.email, admin_person_path(person)
      end
    end
  end

  # Show users who have rations in sprint
  sidebar 'Ordered already', only: :show do
    table_for Person.with_rations_for(sprint.id) do
      column 'Name' do |person|
        link_to person.name, admin_person_path(person)
      end
      column 'Email' do |person|
        link_to person.email, admin_person_path(person)
      end
    end
  end

  # New and update form
  form do |f|
    f.inputs 'Sprint' do
      f.input :title
      f.input :started_at, as: :datepicker
      f.input :finished_at, as: :datepicker
      f.input :state,
              as: :select,
              include_blank: false,
              collection: %w(pending running closed)
    end

    f.actions
  end

  # Generate pdf and send to user
  member_action :report, method: :get do
    _sprint = Sprint.find(params[:id])
    _pdf = ReportPdf.new(_sprint)

    send_data _pdf.render,
              filename: 'report.pdf',
              disposition: 'inline',
              type: 'application/pdf'
  end
end
