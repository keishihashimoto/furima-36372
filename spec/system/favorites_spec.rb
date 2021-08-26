require 'rails_helper'

RSpec.describe 'Favorites', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  describe 'お気に入り登録の結合テスト' do
    context 'お気に入り登録ができるとき' do
      it 'ログインしていればお気に入り登録ができる' do
        # サインインする
        sign_in_support(@user)
        # 商品詳細ページに遷移する
        expect(current_path).to eq root_path
        visit item_path(@item)
        # 画面上にお気に入りの数が表示されている
        expect(page).to have_selector '.star-count', text: @item.favorites.length
        # お気に入りのボタンを押すとお気に入りの数が一つ増える
        expect do
          find('.star-count', text: @item.favorites.length).click
        end.to change { Favorite.count }.by(1)
        # ページはトップページから遷移しない
        expect(current_path).to eq item_path(@item)
      end
    end
    context 'お気に入り登録ができない時' do
      it '一度お気に入りボタンを押した商品に関しては、もう一度お気に入りボタンを押してもお気に入り登録されない' do
        # 既に一度お気に入りに登録済の商品を用意
        @favorite = FactoryBot.create(:favorite, item_id: @item.id, user_id: @user.id)
        # サインインする
        sign_in_support(@user)
        # 商品詳細ページに遷移する
        expect(current_path).to eq root_path
        visit item_path(@item)
        # 画面上にお気に入りの数が表示されている
        expect(page).to have_selector '.star-count', text: @item.favorites.length
        # お気に入りのボタンを押すとお気に入り登録が解除される
        expect do
          find('.star-count', text: @item.favorites.length).click
        end.to change { Favorite.count }.by(-1)
        # ページはトップページから遷移しない
        expect(current_path).to eq item_path(@item)
      end
      it '自分が出品している商品にはお気に入り登録ができない' do
        # @userと紐づく商品を用意
        item = FactoryBot.create(:item, user_id: @user.id)
        # サインインする
        sign_in_support(@user)
        # 商品詳細ページに遷移する
        expect(current_path).to eq root_path
        visit item_path(@item)
        # 画面上にお気に入りの数が表示されている
        expect(page).to have_selector '.star-count', text: item.favorites.length
        # お気に入りのボタンを押してもお気に入りの数が一つ増えない
        expect do
          all('.star-count', text: item.favorites.length)[0].click
        end.to change { Favorite.count }.by(0)
        # ページはトップページから遷移しない
        expect(current_path).to eq item_path(@item)
      end
      it 'ログインしていない場合にはお気に入り登録ができない' do
        # 商品詳細ページに遷移する
        visit item_path(@item)
        # @itemのお気に入りの数が表示されている
        expect(page).to have_selector '.star-count', text: @item.favorites.length
        # お気に入りボタンを押してもお気に入りの数は増えない
        expect do
          find('.star-count').click
        end.to change { Favorite.count }.by(0)
        # サインインページに遷移しない
        expect(current_path).to eq item_path(@item)
      end
    end
  end
end
