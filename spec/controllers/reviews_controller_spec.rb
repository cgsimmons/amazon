require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe '#create' do
    let(:product) { create(:product)}
    let(:user) { create(:user)}
    def valid_request
      post :create,
      params: {review: attributes_for(:review),
               product_id: product.id}
    end

    context 'with user signed in' do
      before { request.session[:user_id] = user.id }

      context 'with valid params' do
        it 'created review associated with signed in user' do
          valid_request
          expect(Review.last.user).to eq(user)
        end
        it 'redirects to product show page' do
          valid_request
          expect(response).to redirect_to(product_path(product))
        end
        it 'review is added to DB' do
          before_count = Review.count
          valid_request
          after_count = Review.count
          expect(after_count).to eq(before_count + 1)
        end
      end

      context 'without valid params' do
        def invalid_request
          post :create,
          params: {review: attributes_for(:review, body: nil),
                   product_id: product.id}
        end

        it 'renders products show page' do
          invalid_request
          expect(response).to render_template('products/show')
        end
        it 'review is not added to DB' do
          before_count = Review.count
          invalid_request
          after_count = Review.count
          expect(after_count).to eq(before_count)
        end
      end
    end

    context 'user not signed in' do
      it 'redirected to sign-in page'do
        valid_request
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
