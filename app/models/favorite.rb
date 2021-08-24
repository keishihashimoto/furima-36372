class Favorite < ApplicationRecord
  validates :user_id, numericality: { less_than: 0, message: "Same combination of user and item can't exist." }, if: :not_unique_favorite?
  validates :user_id, numericality: { less_than: 0, message: "You can't favor your items." }, if: :same_user?
  belongs_to :item
  belongs_to :user

  private
  def not_unique_favorite?
    Favorite.exists?(user_id: user_id, item_id: item_id)
  end
  def same_user?
    if user_id != nil && item != nil && item.user != nil
      user_id == item.user.id
    end
  end
end
