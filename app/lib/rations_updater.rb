class RationsUpdater

  def initialize(rations, user)
    @rations = rations
    @person = user
    @dishes = Dish.select(:id, :price)
    @daily_menus = DailyMenu.select(:id, :max_total, :dish_ids)
    @current_rations = DailyRation.select(:id, :quantity, :person_id,
                                               :daily_menu_id, :sprint_id,
                                               :dish_id)
                                  .where(sprint_id: get_sprint_id, 
                                         person_id: @person.id)
                                  .to_a
  end

  def validate!
    @error = validations.map { |e| send(e) }.compact
  end

  def save
    validate!
    if @error.empty?
      insert!
      return 'success'
    else
      return @error
    end
  end

  def insert!
    filter_existing!
    add_person_id!
    records = @rations.map do |item|
      DailyRation.new(price: item.price,
                      quantity: item.quantity,
                      person_id: item.person_id,
                      daily_menu_id: item.daily_menu_id,
                      sprint_id: item.sprint_id,
                      dish_id: item.dish_id)
    end
    DailyRation.import records
  end

  def filter_existing!
    _new_keys = @rations.map(&:dish_id)
    _cur_keys = @current_rations.map(&:dish_id)
    
    # Leave all that aren't in new rations to delete
    @current_rations.delete_if {|i| _new_keys.include?(i.id)}

    # Delete duplicated to not create new rows
    @rations.delete_if {|i| _cur_keys.include?(i.id)}
  end

  def add_person_id!
    @rations.each do |item|
      item.person_id = @person.id
    end
  end

  def get_sprint_id
    # The hacks
    @rations.first.sprint_id
  end

  def validations
    [
      :all_rations_for_same_sprint?,
      :all_dishes_real?,
      :all_dishes_are_in_corresponding_menu?,
      :all_dishes_have_correct_price?,
      :sprint_is_not_ended?,
      :all_menus_prices_below_maximum?
    ]
  end

  def all_rations_for_same_sprint?
    _sprints = @rations.group_by(&:sprint_id)
    
    return nil if _sprints.keys.length < 2

    "Got rations for #{_sprints.keys}, expected for one"
  end

  def all_dishes_real?
    _new = @rations.map(&:dish_id)
    _current = @dishes.pluck(:id)

    _unknown = _new - _current

    return nil if _unknown.empty?

    "Got unknown dishes: #{_unknown}"
  end

  def all_dishes_are_in_corresponding_menu?
    _by_days = @rations.group_by(&:daily_menu_id)
    _by_days.each do |id, item|
      _new = item.map(&:dish_id)
      _avaliable = @daily_menus.select{|i| i.id == id}.first.dish_ids

      _unknown = _new - _avaliable

      unless _unknown.empty?
        return "Dishes #{_unknown} in day #{id} aren't served that day"
      end
    end
    return nil
  end

  def all_dishes_have_correct_price?
    _dishes = @dishes.pluck(:id, :price)
    @rations.each do |_new|
      _curr = _dishes.find {|i| i[0] == _new.dish_id}
      if _curr[1] != _new.price
        return "Dish with id #{_new.dish_id} has price #{_new.price} but real price is #{_curr[1]}"
      end
    end
    nil
  end

  def sprint_is_not_ended?
    _sprint = Sprint.find(get_sprint_id)
    return nil if _sprint.state == 'pending'

    "Sprint targeted is in '#{_sprint.state}' state"  
  end

  def all_menus_prices_below_maximum?
    _new = @rations.group_by { |i| i.daily_menu_id}

    _new.each do |id, rations|
      _sum = rations.reduce(0) {|memo, item| memo += item.price }
      if _sum > @daily_menus.select{|i| i.id == id}.first.max_total
        return "Sum for day #{id} is bigger than maximum"
      end
    end
    nil
  end

end