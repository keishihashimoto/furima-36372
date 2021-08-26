class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create], if: :favorites_controller?
  def create
    if user_signed_in?
      user_id = current_user.id
      @item = Item.find(params[:item_id])
      item_id = @item.id
      @favorite = Favorite.create(favorite_params)
    else
      redirect_to new_user_session_path
    end
  end

  private
  def favorite_params
    params.permit(:item_id).merge(user_id: current_user.id)
  end

  def favorites_controller?
    controller_name == "favorites"
  end
end
