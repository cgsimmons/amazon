class HomeController < ApplicationController

  def index
  end

  def about
  end

  def contact
  end

  def faq
  end

  def contact_submit
    @name = params[:full_name]
  end

end
