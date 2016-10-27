require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'requires a title' do
      product = build :product, title: nil
      product.valid?
      expect(product.errors).to have_key(:title)
    end
    it 'requires a price' do
      product = build :product, price: nil, sale_price: nil
      product.valid?
      expect(product.errors).to have_key(:price)
    end
    it 'requires price more than 0' do
      product = build :product, price: -2
      product.valid?
      expect(product.errors).to have_key(:price)
    end

    it 'requires a unique title' do
      create :product, attributes_for(:product, title: 'Title')
      product = build :product,  title: 'Title'
      product.valid?
      expect(product.errors).to have_key(:title)
    end
    it 'requires default sale price equal to price' do
      product = build :product, title:'title', price:40, sale_price: nil
      product.valid?
      expect(product[:sale_price]).to eq(product[:price])
    end
    it 'requires price less than or equal to price' do
      product = build :product, price: 10, sale_price: 30
      product.valid?
      expect(product.errors).to have_key(:sale_price)
    end
    it 'title is capitalized after saving' do
      product = build :product, title:'uppercase', price:10, description: "A little description"
      product.save
      expect(Product.last[:title]).to eq('Uppercase')
    end
    it 'description must be present' do
      product = build :product, title:'New', price:10, description: nil
      product.valid?
      expect(product.errors).to have_key(:description)
    end
  end
  describe 'methods' do
    it 'requires on_sale? method' do
      product = build :product, title:'title', price:5, sale_price:nil
      product.valid?
      result = product.on_sale?
      expect(result).to equal(false)
    end

    it 'requires on_sale? method' do
      product = build :product, title:'title', price:5, sale_price: 3
      product.valid?
      result = product.on_sale?
      expect(result).to equal(true)
    end

    it 'search by title and description' do
      create :product, attributes_for(:product, title: 'not result', description: 'not a result')
      create :product, attributes_for(:product, title: 'solution1', description: "Im the first one")
      create :product, attributes_for(:product, title: 'second', description: 'I am solution2')
      create :product, attributes_for(:product, title: 'not a result2', description: 'not a result')

      search = Product.search('solution')
      result = []
      search.each {|element| result << element[:title]}

      expect(result).to eq(['Solution1', 'Second'])
    end
  end
  describe 'associations' do
    it 'must have many reviews' do
      product = create :product
      create :review, attributes_for(:review, product_id: product.id)
      create :review, attributes_for(:review, product_id: product.id)
      create :review, attributes_for(:review, product_id: product.id)

      expect(product.reviews.count).to eq(3)
    end
  end
end
