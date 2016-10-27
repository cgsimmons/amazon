class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
  end
  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_path
  end
  def edit
    @question = Question.find(params[:id])
  end
end
