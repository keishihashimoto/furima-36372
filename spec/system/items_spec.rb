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
        # 検索結果にその商品の１枚目の画像が含まれている
        expect(page).to have_selector("img[src$='test_image.png']")
        # 検索結果にその商品の2枚目の画像が含まれていない
        expect(page).to have_no_selector("img[src$='test_image_2.png']")
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
        # 検索結果にその商品の１枚目の画像が含まれていない
        expect(page).to have_no_selector("img[src$='test_image.png']")
        # 検索結果にその商品の2枚目の画像が含まれていない
        expect(page).to have_no_selector("img[src$='test_image_2.png']")
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
        # 検索結果にその商品の１枚目の画像が含まれていない
        expect(page).to have_no_selector("img[src$='test_image.png']")
        # 検索結果にその商品の2枚目の画像が含まれていない
        expect(page).to have_no_selector("img[src$='test_image_2.png']")
        # 検索結果のページに"『#{params[:search]}』の検索結果はありませんでした。"の文字列が含まれている。
        expect(page).to have_content("『#{search}』の検索結果はありませんでした。")
      end
    end
  end
  describe "商品詳細ページの結合テスト" do
    it "ログインしていない時" do
      # トップページに遷移する
      visit root_path
      # 商品詳細へのリンクをクリックしてページを切り替える。
      click_link @item.name
      expect(current_path).to eq item_path(@item)
      # 商品名が表示されている。
      expect(page).to have_content(@item.name)
      # 商品画像１枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image.png']")
      # 商品画像２枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image_2.png']")
      # 商品の価格が表示されている
      expect(page).to have_content(@item.price)
      # 送料についての説明が表示されている。
      expect(page).to have_selector ".item-postage", text: @item.postage.text
      # 購入ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "購入画面に進む"
      # 編集ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "商品の編集"
      # 削除ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "削除"
      # 商品の説明が表示されている。
      expect(page).to have_selector "span", text: @item.description
      # 商品の出品者名が表示されている。
      expect(page).to have_selector "th", text: "出品者"
      expect(page).to have_selector "td", text: @item.user.nickname
      # 商品のカテゴリーが表示されている。
      expect(page).to have_selector "th", text: "カテゴリー"
      expect(page).to have_selector "td", text: @item.category.name
      # 商品の状態が表示されている。
      expect(page).to have_selector "th", text: "商品の状態"
      expect(page).to have_selector "td", text: @item.condition.text
      # 商品の配送料の負担が表示されている。
      expect(page).to have_selector "th", text: "配送料の負担"
      expect(page).to have_selector "td", text: @item.postage.text
      # 商品の発送元の地域が表示されている。
      expect(page).to have_selector "th", text: "発送元の地域"
      expect(page).to have_selector "td", text: @item.prefecture.name
      # 商品の発送日の目安が表示されている。
      expect(page).to have_selector "th", text: "発送日の目安"
      expect(page).to have_selector "td", text: @item.delivery.text
      # お気に入り登録ボタンが表示されている
      expect(page).to have_selector "span", text: "お気に入り #{@item.favorites.length}"
    end
    it "ログイン後に、ほかのユーザーの商品のページに移動した時" do
      # ログイン用のユーザーの生成
      user = FactoryBot.create(:user)
      # ログインする
      sign_in_support(user)
      # 商品詳細へのリンクをクリックしてページを切り替える。
      click_link @item.name
      expect(current_path).to eq item_path(@item)
      # 商品名が表示されている。
      expect(page).to have_content(@item.name)
      # 商品画像１枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image.png']")
      # 商品画像２枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image_2.png']")
      # 商品の価格が表示されている
      expect(page).to have_content(@item.price)
      # 送料についての説明が表示されている。
      expect(page).to have_selector ".item-postage", text: @item.postage.text
      # 購入ボタンが表示されている。
      expect(page).to have_selector "a", text: "購入画面に進む"
      # 編集ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "商品の編集"
      # 削除ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "削除"
      # 商品の説明が表示されている。
      expect(page).to have_selector "span", text: @item.description
      # 商品の出品者名が表示されている。
      expect(page).to have_selector "th", text: "出品者"
      expect(page).to have_selector "td", text: @item.user.nickname
      # 商品のカテゴリーが表示されている。
      expect(page).to have_selector "th", text: "カテゴリー"
      expect(page).to have_selector "td", text: @item.category.name
      # 商品の状態が表示されている。
      expect(page).to have_selector "th", text: "商品の状態"
      expect(page).to have_selector "td", text: @item.condition.text
      # 商品の配送料の負担が表示されている。
      expect(page).to have_selector "th", text: "配送料の負担"
      expect(page).to have_selector "td", text: @item.postage.text
      # 商品の発送元の地域が表示されている。
      expect(page).to have_selector "th", text: "発送元の地域"
      expect(page).to have_selector "td", text: @item.prefecture.name
      # 商品の発送日の目安が表示されている。
      expect(page).to have_selector "th", text: "発送日の目安"
      expect(page).to have_selector "td", text: @item.delivery.text
      # お気に入り登録ボタンが表示されている
      expect(page).to have_selector "span", text: "お気に入り #{@item.favorites.length}"
    end
    it "ログイン後に、自分の商品のページに移動した時" do
      # ログインする
      sign_in_support(@item.user)
      # 商品詳細へのリンクをクリックしてページを切り替える。
      click_link @item.name
      expect(current_path).to eq item_path(@item)
      # 商品名が表示されている。
      expect(page).to have_content(@item.name)
      # 商品画像１枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image.png']")
      # 商品画像２枚目が表示されている。
      expect(page).to have_selector("img[src$='test_image_2.png']")
      # 商品の価格が表示されている
      expect(page).to have_content(@item.price)
      # 送料についての説明が表示されている。
      expect(page).to have_selector ".item-postage", text: @item.postage.text
      # 購入ボタンが表示されていない。
      expect(page).to have_no_selector "a", text: "購入画面に進む"
      # 編集ボタンが表示されている。
      expect(page).to have_selector "a", text: "商品の編集"
      # 削除ボタンが表示されていない。
      expect(page).to have_selector "a", text: "削除"
      # 商品の説明が表示されている。
      expect(page).to have_selector "span", text: @item.description
      # 商品の出品者名が表示されている。
      expect(page).to have_selector "th", text: "出品者"
      expect(page).to have_selector "td", text: @item.user.nickname
      # 商品のカテゴリーが表示されている。
      expect(page).to have_selector "th", text: "カテゴリー"
      expect(page).to have_selector "td", text: @item.category.name
      # 商品の状態が表示されている。
      expect(page).to have_selector "th", text: "商品の状態"
      expect(page).to have_selector "td", text: @item.condition.text
      # 商品の配送料の負担が表示されている。
      expect(page).to have_selector "th", text: "配送料の負担"
      expect(page).to have_selector "td", text: @item.postage.text
      # 商品の発送元の地域が表示されている。
      expect(page).to have_selector "th", text: "発送元の地域"
      expect(page).to have_selector "td", text: @item.prefecture.name
      # 商品の発送日の目安が表示されている。
      expect(page).to have_selector "th", text: "発送日の目安"
      expect(page).to have_selector "td", text: @item.delivery.text
      # お気に入り登録ボタンが表示されている
      expect(page).to have_selector "span", text: "お気に入り #{@item.favorites.length}"
    end
  end
  describe "商品出品機能の結合テスト" do
    it "必要な情報が入力されていれば出品ができ、トップページに表示される。" do
      # 出品するitemの用意
      item = FactoryBot.build(:item)
      user = FactoryBot.create(:user)
      # 既存の商品の削除
      @item.destroy
      # ログインする
      sign_in_support(user)
      # "出品する"ボタンをクリックする。
      click_link "出品する"
      # 商品出品ページに遷移する。
      expect(current_path).to eq new_item_path
      # 商品の画像を設定する（一枚目）。
      image_path_1 = Rails.root.join("public/images/test_image.png")
      image_path_2 = Rails.root.join("public/images/test_image_2.png")
      attach_file("item[images][]", image_path_1)
      # １枚目の画像が表示される。
      # expect(page).to have_selector("img[src$='test_image.png']")
      # ２枚目の画像を選択するフォームが表示される。
      expect(page).to have_selector "#item-image-1"
      # ２枚目の画像を選択する。
      attach_file("item-image-1", image_path_2)
      # ２枚目の画像が表示される。
      # expect(page).to have_selector("img[src$='test_image.png_2']")
      # ３つ目の画像フォームは表示されない。
      expect(page).to have_no_selector "#item-image-2"
      # 商品情報を設定する。
      fill_in "item[name]", with: item.name
      fill_in "item[description]", with: item.description
      find("#item-category").find("option[value='#{item.category_id}']").select_option
      find("#item-sales-status").find("option[value='#{item.condition_id}']").select_option
      find("#item-shipping-fee-status").find("option[value='#{item.postage_id}']").select_option
      find("#item-prefecture").find("option[value='#{item.prefecture_id}']").select_option
      find("#item-scheduled-delivery").find("option[value='#{item.delivery_id}']").select_option
      fill_in "item[price]", with: item.price
      # 手数料と利益が表示されている。
      # expect(page).to have_selector ("span[id='add-tax-price']"), text: @item.price * 0.1
      # expect(page).to have_selector ("span[id='profit']"), text: (@item.price - @item.price * 0.1)
      # 出品ボタンを押す。
      click_on "出品する"
      # トップページに遷移する。
      expect(current_path).to eq root_path
      # 出品した商品の名前が表示されている
      expect(page).to have_content(item.name)
      # 出品した商品の画像が表示されている（１枚目）。
      expect(page).to have_selector("img[src$='test_image.png']")
      # 出品した商品の画像が表示されていない（２枚目）。
      expect(page).to have_no_selector("img[src$='test_image_2.png']")
      # Sold Out!!が表示されていない。
      expect(page).to have_no_content("Sold Out!!")
    end
  end
end
