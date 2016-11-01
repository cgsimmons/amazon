class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    review = Review.find_by(id: params[:review_id])
    like = Like.new(user: current_user, review: review)

    if cannot? :like, review
      redirect_to :back, alert: '‼ Access Denied ‼'
    elsif like.save
      redirect_to :back, notice: 'You have liked a review.'
    else
      redirect_to :back, alert: like.errors.full_messages.join(", ")
    end

  end

  def destroy
    like = Like.find_by(id: params[:id])

    if like.destroy
      redirect_to :back, notice: 'You have unliked a review.'
    else
      redirect_to :back, alert: like.errors.full_messages.join(", ")
    end
  end

end
