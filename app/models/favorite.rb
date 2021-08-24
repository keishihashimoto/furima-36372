class Favorite < ApplicationRecord
  validates :user_id, numericality: { less_than: 0 }, if: :not_unique_favorite?
  belongs_to :item
  belongs_to :user

  private
  def not_unique_favorite?
    Favorite.exists?(user_id: user_id, item_id: item_id)
  end
end
