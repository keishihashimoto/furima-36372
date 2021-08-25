require 'rails_helper'

RSpec.describe Favorite, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @favorite = FactoryBot.build(:favorite, item_id: @item.id, user_id: @user.id)
    sleep 0.1
  end
  describe "Favoriteモデルの単体テスト" do
    context "保存ができる時" do
      it "userとitemの両方に紐づいていれば保存ができる" do
        expect(@favorite).to be_valid
      end
    end
    context "保存ができない時" do
      it "同じuserとitemの組み合わせが既に存在する場合には保存ができない" do
        favorite = FactoryBot.create(:favorite, user_id: @user.id, item_id: @item.id)
        @favorite.valid?
        expect(@favorite.errors.full_messages).to include("User Same combination of user and item can't exist.")
      end
      it "userが紐づいていない場合には保存ができない" do
        @favorite.user = nil
        @favorite.valid?
        expect(@favorite.errors.full_messages).to include("User must exist")
      end
      it "itemが紐づいていない場合には保存ができない" do
        @favorite.item = nil
        @favorite.valid?
        expect(@favorite.errors.full_messages).to include("Item must exist")
      end
      it "自分が出品た商品に関してはお気に入り登録ができない" do
        item = FactoryBot.create(:item)
        favorite = FactoryBot.build(:favorite, item_id: item.id, user_id: item.user.id)
        favorite.valid?
        expect(favorite.errors.full_messages).to include("User You can't favor your items.")
      end
    end
  end
end
