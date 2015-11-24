ActiveAdmin.register Sprint do
  index do
    selectable_column
    column :id
    column :title
    column :state
    column :started_at
    column :finished_at
    actions
    column 'Report' do |sprint|
      link_to 'Report', { id: sprint.id, action: 'report' }, method: :get
    end
  end

  form do |f|
    f.inputs 'Sprint' do
      f.input :title
      f.input :started_at, as: :datepicker
      f.input :finished_at, as: :datepicker
      f.input :state, as: :select, collection: %w(pending running closed)
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

  permit_params :title, :started_at, :finished_at, :state
end
