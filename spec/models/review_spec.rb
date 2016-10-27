require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validates' do
    it 'must have a star_count' do
      review = build :review, attributes_for(:review, star_count: nil)
      review.valid?
      expect(review.errors).to have_key(:star_count)
    end
    it 'must have a star_count between 1 and 5' do
      review = build :review, attributes_for(:review, star_count: 0)
      review.valid?
      expect(review.errors).to have_key(:star_count)
    end
    it 'must have a body' do
      review = build :review, attributes_for(:review, body: nil)
      review.valid?
      expect(review.errors).to have_key(:body)
    end
  end

end
