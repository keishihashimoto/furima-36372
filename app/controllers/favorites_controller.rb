class FavoritesController < ApplicationController
  def create
    unless Favorite.exists?(user_id: current_user.id, item_id: params[:item_id])
      @favorite = Favorite.new(favorite_params)
      @favorite.save
    end
  end

  private
  def favorite_params
    params.permit(:item_id).merge(user_id: current_user.id)
  end
end
