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

   respond_to do |format|
     format.html {render}
     format.json {render json: @products.to_json}
   end
  end

  def new
    @product = Product.new
  end

  def create
    product_params = params.require(:product).permit([:title, :description, :price, :category_id, tag_ids: []])
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
    respond_to do |format|
      format.html {render}
      format.json {render json: @product.to_json(include: :reviews)}
    end
  end

  def edit
    @product = Product.find(params[:id])
    if cannot? :manage_product, @product
      redirect_to product_path(@product), alert: 'Access Denied!'
    end
  end

  def update
    @product = Product.find(params[:id])
    product_params = params.require(:product).permit(:title, :description, :price, tag_ids: [])
    if cannot? :manage_product, @product
      redirect_to product_path(@product), alert: 'Access Denied!'
    elsif @product.update product_params
      redirect_to product_path(@product), notice: 'Saved product changes.'
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if cannot? :manage_product, @product
      redirect_to product_path(@product), alert: 'Access Denied!'
    elsif @product.destroy
      redirect_to products_path, notice: 'Product deleted.'
    else
      redirect_to product_path(@product), alert: @product.errors.full_messages.join(", ")
    end
  end
end
