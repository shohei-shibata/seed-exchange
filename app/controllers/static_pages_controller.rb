class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @plant = current_user.plants.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
