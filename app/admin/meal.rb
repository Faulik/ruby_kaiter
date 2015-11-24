ActiveAdmin.register Meal do
  menu parent: 'Dish'

  permit_params :title,
                :price,
                :category_id,
                :description

  # Index page
  index do
    selectable_column
    column :id
    column 'title' do |dish|
      link_to dish.title, admin_meal_path(dish)
    end
    column :category
    column :description
    column :price
    actions
  end

  # Filters
  filter :title
  filter :category, as: :check_boxes
  filter :price, as: :numeric

  # Show page
  show do
    panel 'Meal Details' do
      attributes_table_for meal do
        row('id') { meal.id }
        row('title') { meal.title }
        row('category') { meal.category }
        row('description') { meal.description }
        row('price') { meal.price }
      end
    end
  end

  # Update and create page
  form do |f|
    f.inputs 'Meal' do
      f.input :title
      f.input :category_id,
              as: :select,
              include_blank: false,
              collection: Category.all
      f.input :price
      f.input :description
    end

    f.actions
  end
end
