ActiveAdmin.register Person do
  permit_params :name, :email, :password, :password_confirmation
  
  # Index page
  index do
    column :id
    column 'name' do |person|
      link_to person.name, admin_person_path(person)
    end
    column :email
    column :authentication_token
    actions
  end

  # Show page
  show do
    panel 'Person Details' do
      attributes_table_for person do
        row('id') { person.id }
        row('name') { person.name }
        row('email') { person.email }
        row('sign_in_count') { person.sign_in_count }
        row('last_sign_in_at') { person.last_sign_in_at }
        row('last_sign_in_ip') { person.last_sign_in_ip }
        row('locked_at') { person.locked_at }
      end
    end

    _last_sprint = Sprint.last
    panel "Last sprint orders: #{_last_sprint.title}" do
      table_for DailyRation.where(sprint_id: _last_sprint.id) do
        column :title
        column :price
        column :quantity
        column 'Day' do |daily_ration|
          daily_ration.daily_menu.title
        end
      end
    end
  end

  # Create and update form
  form do |f|
    f.inputs 'Person' do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
