class User < ApplicationRecord
  has_secure_password
  has_many :products, dependent: :destroy
  has_many :reviews, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false },
                  format: VALID_EMAIL_REGEX

  def full_name
    "#{self.first_name} #{self.last_name}".titlecase
  end

  private
  def downcase_email
    self.email.downcase! if email.present?
  end


end
