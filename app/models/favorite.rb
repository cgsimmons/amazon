class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true, uniqueness: {scope: :product_id}
  validates :product_id, presence: true

end
