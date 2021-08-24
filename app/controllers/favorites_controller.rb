class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(favorite_params)
    if @favorite.save
    end
  end

  private
  def favorite_params
    params.require(:favorite).permit(:item_id).merge(user_id: current_user.id)
  end
end
