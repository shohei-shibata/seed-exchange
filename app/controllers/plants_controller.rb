class PlantsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @plant = current_user.plants.build(plant_params)
    if @plant.save
      flash[:success] = "New plant added successfully!"
      redirect_to root_url 
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @plant.destroy
    flash[:success] = "Plant deleted"
    redirect_to request.referrer || root_url
  end

  private

    def plant_params
      params.require(:plant).permit(:name, :name_latin)
    end

    def correct_user
      @plant = current_user.plants.find_by(id: params[:id])
      redirect_to root_url if @plant.nil?
    end
end
