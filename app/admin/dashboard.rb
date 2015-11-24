ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    # Show all pending sprints
    panel 'Pending sprints' do
      table_for Sprint.includes(:daily_rations).where(state: 'pending') do
        column 'title' do |sprint|
          link_to sprint.title, admin_sprint_path(sprint)
        end
        column :started_at
        column :finished_at
        column 'have ordered' do |sprint|
          Person.with_rations_for(sprint.id).count
        end
        column 'haven\'t ordered' do |sprint|
          Person.without_rations_for(sprint.id).count
        end
      end
    end
  end
end
