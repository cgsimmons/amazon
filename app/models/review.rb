class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :star_count,
            presence: true,
            numericality: {greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5}
  validates :body, presence: true

  def like_for(user)
    likes.find_by(user: user)
  end
end
