class BussinesDish < Dish
  validates :children_ids, presence: true
end