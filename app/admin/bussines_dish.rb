ActiveAdmin.register BussinesDish do
  menu parent: 'Dish'

  permit_params :title,
                :price,
                :category_id,
                :description,
                children_ids: []

  # Index page
  index do
    selectable_column
    column :id
    column 'title' do |dish|
      link_to dish.title, admin_bussines_dish_path(dish)
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
    panel 'Bussines Dish Details' do
      attributes_table_for bussines_dish do
        row('id') { bussines_dish.id }
        row('title') { bussines_dish.title }
        row('category') { bussines_dish.category }
        row('description') { bussines_dish.description }
        row('price') { bussines_dish.price }
        row('children_ids') { bussines_dish.children_ids }
      end
    end
  end

  # Update and create form
  form do |f|
    f.inputs 'Bussines dish' do
      f.input :title
      f.input :category_id,
              as: :select,
              include_blank: false,
              collection: Category.all
      f.input :price
      f.input :description
    end

    f.inputs 'Dishes' do
      f.input :children_ids,
              label: 'Dishes',
              as: :select,
              multiple: true,
              collection: option_groups_from_collection_for_select(Category.includes(:dishes).where(dishes: { type: 'Meal' }), :dishes, :title, :id, :title),
              input_html: { class: 'select2-list' }
    end
    f.actions
  end

  # Fixes select2 nil as first item
  controller do
    def create
      _params = permitted_params['bussines_dish']
      _params['children_ids'].reject!(&:empty?)
      _dish = BussinesDish.new(_params)
      if _dish.save
        redirect_to admin_bussines_dishes_path
      else
        redirect_to new_admin_bussines_dish_path, alert: 'Something went wrong'
      end
    end

    def update
      _dish = BussinesDish.find(params[:id])
      _params = permitted_params['bussines_dish']
      _params['children_ids'].reject!(&:empty?)
      if _dish.update(_params)
        redirect_to admin_bussines_dish_path(_dish)
      else
        redirect_to edit_admin_bussines_dish_path, alert: 'Something went wrong'
      end
    end
  end

  # Shows dishes in bussines dish
  sidebar 'Dishes', only: :show do
    table_for Meal.find(bussines_dish.children_ids) do
      column :id
      column 'Title' do |dish|
        link_to dish.title, admin_meal_path(dish)
      end
      column :price
    end
  end
end
