class FavoritesController < ApplicationController
  def create
    user_id = current_user.id
    item_id = params[:item_id]
    @Favorite = Favorite.create(favorite_params)
  end

  private
  def favorite_params
    params.permit(:item_id).merge(user_id: current_user.id)
  end
end
