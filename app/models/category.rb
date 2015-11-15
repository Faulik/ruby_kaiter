# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string(45)
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  validates :title, presence: true
  
  has_many :dishes
  
  def as_json(options = nil)
    super ({
      only: [:id, :title]
      }).merge(options || {})
  end
end
