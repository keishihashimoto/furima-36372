class UsersController < ApplicationController
  before_action: authenticate_user!, only: [:show], if: :user_controller?
  
  def show
    @user = current_user
    @favorite_message = "#{@user.nickname}さんのお気に入り一覧"
    @item_message = "#{@user.nickname}さんの出品一覧"
    @items = @user.items
    @favorite_items = set_favorite_items
  end

  private

  def set_favorite_items
    favorite_items = []
    Item.order(created_at: 'DESC').each do |item|
      favorite_items << item if Favorite.exists?(item_id: item.id, user_id: current_user.id)
    end
    favorite_items
  end

  def user_controller?
    return if controller_name == "users"
  end
end
