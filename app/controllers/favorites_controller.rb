class FavoritesController < ApplicationController
  before_action :authenticate_user

  def index
    @user = current_user
    @favorites = @user.favorite_products.page(params[:page]).per(10)
  end

  def create
    product = Product.find(params[:product_id])
    favorite = Favorite.new(user: current_user, product: product)
    if cannot? :favorite, product
      redirect_to :back, alert: '‼ Access Denied ‼'
    elsif favorite.save
      redirect_to :back, notice: '❤Added to your favorites!❤'
    else
      redirect_to :back, alert: favorite.errors.full_messages.join(", ")
    end
  end

  def destroy
    favorite = Favorite.find_by(id: params[:id])
    product = favorite.product
    if favorite.destroy
      redirect_to :back, notice: '💔Unfavorited product.💔'
    else
      redirect_to :back, alert: favorite.errors.full_messages.join(", ")
    end
  end
end
