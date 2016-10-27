class ReviewsController < ApplicationController
  before_action :authenticate_user

  def create
    @product = Product.find(params[:product_id])
    review_params = params.require(:review).permit(:body, :star_count)
    @review = Review.new review_params
    @review.product = @product
    @user = current_user
    @review.user = @user
    if @review.save
      Product.decrement_counter(:hit_count, @product[:id])
      redirect_to product_path(@product), notice: 'Review added successfully.'
    else
      render 'products/show'
    end
  end

  def destroy
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    @review.destroy
    Product.decrement_counter(:hit_count, @product[:id])
    redirect_to product_path(@product), notice: "Review deleted successfully."
  end

end