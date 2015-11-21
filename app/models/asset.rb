# == Schema Information
#
# Table name: assets
#
#  id         :integer          not null, primary key
#  filename   :string(45)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Asset < ActiveRecord::Base
end
