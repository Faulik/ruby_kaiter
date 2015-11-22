ActiveAdmin.register Sprint do
  form do |f|
    f.inputs 'Sprint' do
      f.input :title
      f.input :started_at, as: :datepicker
      f.input :finished_at, as: :datepicker
      f.input :state, as: :select, collection: %w(pending running closed)
    end
    f.actions
  end

  permit_params :title, :started_at, :finished_at, :state
end
