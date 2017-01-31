class ReviewsController < ApplicationController
  before_action :authenticate_user


  def create
    @product = Product.find(params[:product_id])
    review_params = params.require(:review).permit(:body, :star_count)
    @review = Review.new review_params
    @review.product = @product
    @user = current_user
    @review.user = @user

    respond_to do |format|

      if cannot? :review, @product
        format.js {render :create_failure}
        format.html {redirect_to product_path(@product), notice: 'Cannot review your own product!'}
      elsif @review.save
        ReviewsMailer.notify_product_owner(@review).deliver_now
        Product.decrement_counter(:hit_count, @product[:id])
        format.js {render :create_success}
        format.html { redirect_to product_path(@product), notice: 'Review added successfully.'}
      else
        format.js {render :create_failure}
        format.html { render 'products/show' }
      end

    end
  end

  def destroy
    # @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    @product = @review.product
    Product.decrement_counter(:hit_count, @product[:id])

    respond_to do |format|

      if (can?(:destroy_review, @review) && @review.destroy)
        format.js {render}
        format.html {redirect_to product_path(@product), notice: "Review deleted successfully."}
      else
        format.html { redirect_to root_path, alert: 'Access Denied'}
        format.js { render js: 'alert("Access denied.")'; }
      end

    end
  end

end
