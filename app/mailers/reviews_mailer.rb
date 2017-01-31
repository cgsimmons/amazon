class ReviewsMailer < ApplicationMailer

  def notify_product_owner(review)
    @review = review
    @product = review.product
    @user = @product.user

    mail(to: @user.email, subject: "One of your products has been reviewed!") if @user && @user.email
  end

end
