ActiveAdmin.register Sprint do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  form do |f|
    f.inputs 'Sprint' do
      f.input :title
      f.input :started_at, as: :datepicker
      f.input :finished_at, as: :datepicker
      f.input :state, as: :select, collection: ['pending', 'running', 'closed']
    end
    f.actions
  end

end
