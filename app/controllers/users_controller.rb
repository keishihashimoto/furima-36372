class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show], if: :users_controller?
  before_action :visit_root, only: [:show], unless: :same_user?
  
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

  def users_controller?
    return controller_name == "users"
  end

  def same_user?
    if user_signed_in?
      return current_user.id == params[:id]
    end
  end

  def visit_root
    redirect_to root_path
  end
end
