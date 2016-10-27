class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :user
  belongs_to :category
  belongs_to :user
  before_save :capitalize_title
  before_validation :set_defaults

  validates :title, presence: true,
            :uniqueness => {case_sensitive: false}

  validates :price, presence: true, numericality: {greater_than: 0}

  validates :sale_price, numericality: {less_than_or_equal_to: :price}

  validates :description, presence: true,
            length: {minimum: 10}

  validate :no_competition
  #
  # def self.search (keyword)
  #   self.where('products.title ILIKE :query OR products.description ILIKE :query', query: "%#{keyword}%")
  # end
  #

    RESERVED_WORDS = [
      'Microsoft',
      'Sony',
      'Apple'
    ]

    def no_competition
      if /#{RESERVED_WORDS.join('|')}/ === description
        errors.add(StandardError.new(:description), "We don't like competition!")
      end
    end

  def on_sale?
    self.sale_price < self.price
  end

  def self.search(search_str)
    where("title ILIKE ? OR description ILIKE ?", "%#{search_str}%", "%#{search_str}%")
  end
  #
  # def self.search_sort_paginate(search_str, sort_by_column, current_page, per_page_count)
  #   where("title ILIKE ? OR description ILIKE ?", "%#{search_str}%", "%#{search_str}%").
  #   order(sort_by_column.to_s).
  #   offset((current_page-1)*per_page_count).
  #   limit(per_page_count)
  # end

  def favorite_for(user)
    favorites.find_by(user: user)
  end

  private
  def set_defaults
    self.sale_price ||= self.price
    self.hit_count ||= 1
  end

  def capitalize_title
    self.title = self.title.capitalize
  end
end
