class ProductsController < ApplicationController
    before_action :authenticate_user, except: [:index, :show]

  def index
    @products = Product.all
    if params[:search]
      @products = Product.search(params[:search]).
      order(params[:sort_by]).page(params[:page]).per(10)
      # @products = Product.search_title_desc(params[:search]).order(title: :ASC).page(params[:page]).per(10)
    else
     @products = Product.order(title: :ASC).page(params[:page]).per(10)
   end
  end

  def new
    @product = Product.new
  end

  def create
    product_params = params.require(:product).permit([:title, :description, :price, :category_id])
    @product = Product.new product_params
    @user = current_user
    @product.user = @user
    if @product.save
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def show
    @product = Product.find params[:id]
    @review = Review.new
    @favorite = @product.favorite_for(current_user)
    Product.increment_counter(:hit_count, @product[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    product_params = params.require(:product).permit(:title, :description, :price)
    if @product.update product_params
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end
end
