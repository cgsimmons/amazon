class LikesController < ApplicationController
  before_action :authenticate_user

  def create
    @review = Review.find_by(id: params[:review_id])
    like = Like.new(user: current_user, review: @review)

    respond_to do |format|

      if cannot? :like, @review
        format.js {render js: 'alert("Access denied!");'}
        format.html {redirect_to :back, alert: '‼ Access Denied ‼'}
      elsif like.save
        format.js {render :change_like}
        format.html{redirect_to :back, notice: 'You have liked a review.'}
      else
        format.js {render js: 'alert("Access denied!");'}
        format.html {redirect_to :back, alert: like.errors.full_messages.join(", ")}
      end

    end
  end


  def destroy
    like = Like.find_by(id: params[:id])
    @review = like.review
    respond_to do |format|

      if like.destroy
        format.js {render :change_like}
        format.html {redirect_to :back, notice: 'You have unliked a review.'}
      else
        format.js {render js: 'alert("Access denied!");'}
        format.html {redirect_to :back, alert: like.errors.full_messages.join(", ")}
      end

    end
  end

end
