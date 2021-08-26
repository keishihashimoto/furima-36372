require 'rails_helper'

RSpec.describe 'Items', type: :system do
  before do
    @item = FactoryBot.create(:item)
  end
  describe '検索機能の結合テスト' do
    context '購入されていない商品の名前を入力したとき' do
      it '購入されていない商品名であれば検索結果に表示される' do
        # トップページに移動
        visit root_path
        # 検索フォームに商品名を入力
        fill_in 'search', with: @item.name
        # 検索ボタンをクリック
        find('button[id="search-btn"]').click
        # 検索結果のページに遷移
        expect(current_path).to eq search_items_path
        # 検索結果に@itemが含まれている
        expect(page).to have_selector 'h3', text: @item.name
        # 検索結果のページに"『#{params[:search]}』の検索結果"の文字列が含まれている。
        expect(page).to have_content("『#{@item.name}』の検索結果")
      end
    end
    context '購入済の商品の名前を入力した時' do
      it '購入済の商品名であれば検索結果に表示されない' do
        # 商品の購入処理
        purchase = FactoryBot.create(:purchase, item_id: @item.id)
        # トップページに移動
        visit root_path
        # 検索フォームに商品名を入力
        fill_in 'search', with: @item.name
        # 検索ボタンをクリック
        find('button[id="search-btn"]').click
        # 検索結果のページに遷移
        expect(current_path).to eq search_items_path
        # 検索結果に@itemが含まれていない
        expect(page).to have_no_selector 'h3', text: @item.name
        # 検索結果のページに"『#{params[:search]}』に関する商品は全て販売済です。"の文字がある
        expect(page).to have_content("『#{@item.name}』に関する商品は全て販売済です。")
      end
    end
    context '出品されていない商品の名前を入力した時' do
      it '出品されていない商品の名前を入力した場合には商品は何も表示されない' do
        # トップページに移動
        visit root_path
        # 検索フォームに商品名とは異なるテキストを入力
        search = "テスト#{@item.name}"
        fill_in 'search', with: search
        # 検索ボタンをクリック
        find('button[id="search-btn"]').click
        # 検索結果のページに遷移
        expect(current_path).to eq search_items_path
        # 検索結果に@itemが含まれていない
        expect(page).to have_no_selector 'h3', text: search
        # 検索結果のページに"『#{params[:search]}』の検索結果はありませんでした。"の文字列が含まれている。
        expect(page).to have_content("『#{search}』の検索結果はありませんでした。")
      end
    end
  end
end
