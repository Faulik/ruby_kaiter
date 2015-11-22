ActiveAdmin.register Person do
  index do
    column :id
    column :name
    column :email
    column :authentication_token
  end

  form do |f|
    f.inputs 'Person' do
      f.input :name
      f.input :email
      f.input :password
    end
    f.actions
  end

  permit_params :name, :email, :password
end
