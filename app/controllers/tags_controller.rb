class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find_by(id: params[:id])
    @products = @tag.products
  end
end