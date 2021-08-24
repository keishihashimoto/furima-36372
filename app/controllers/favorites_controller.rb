class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create], if: :favorites_controller?
  def create
    user_id = current_user.id
    item = Item.find(params[:item_id])
    item_id = item.id
    item_user_id = item.user.id
    @Favorite = Favorite.create(favorite_params)
  end

  private
  def favorite_params
    params.permit(:item_id).merge(user_id: current_user.id)
  end

  def favorites_controller?
    controller_name == "favorites"
  end
end
