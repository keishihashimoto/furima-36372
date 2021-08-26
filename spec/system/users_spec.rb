require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  describe "マイページの結合テスト" do
    context "マイページに入れるとき" do
      it "自分のページにはサインインできる、出品した商品が表示されている(sold out なし)" do
        # @userの商品を一つ出品する
        item = FactoryBot.create(:item, user_id: @user.id)
        # トップページに遷移する
        visit root_path
        # ログインボタンをクリックし、サインインページに移動する
        find('a[class="login"]').click
        expect(current_path).to eq new_user_session_path
        # "サインインする" 
        fill_in "user[email]", with: @user.email
        fill_in "user[password]", with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # "ページ上部のユーザー名をクリック" 
        click_link("#{@user.nickname}")
        # "マイページに遷移する" 
        expect(current_path).to eq user_path(@user)
        # "自分が出品した商品が表示されている（未購入）"
        expect(page).to have_selector ".item-name", text: item.name
        # "未購入の商品にはsold outが表示されていない"
        expect(page).to_not have_content("Sold Out!!") 
      end
      it "自分のページにはサインインできる、出品した商品が表示されている(売却済み、sold out あり)" do
        # @userの商品を一つ出品する
        item = FactoryBot.create(:item, user_id: @user.id)
        purchase = FactoryBot.create(:purchase, item_id: item.id)
        # トップページに遷移する
        visit root_path
        # ログインボタンをクリックし、サインインページに移動する
        find('a[class="login"]').click
        expect(current_path).to eq new_user_session_path
        # "サインインする" 
        fill_in "user[email]", with: @user.email
        fill_in "user[password]", with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # "ページ上部のユーザー名をクリック" 
        click_link("#{@user.nickname}")
        # "マイページに遷移する" 
        expect(current_path).to eq user_path(@user)
        # "@user.nicknameさんの出品一覧"という文字が表示されている
        expect(page).to have_content("#{@user.nickname}さんの出品一覧")
        # "@user.nicknameさんのお気に入り一覧"という文字が表示されている
        expect(page).to have_content("#{@user.nickname}さんのお気に入り")
        # "自分が出品した商品が表示されている（購入済み）"
        expect(page).to have_selector ".item-name", text: item.name
        # "sold outが表示されている"
        expect(page).to have_content("Sold Out!!") 
      end
      it "自分のページにはサインインできる、お気に入り登録した商品が表示されている(sold out なし)" do
        # 他のユーザーの商品にお気に入り登録をする。
        favorite = FactoryBot.create(:favorite, user_id: @user.id)
        item = favorite.item
        # トップページに遷移する
        visit root_path
        # ログインボタンをクリックし、サインインページに移動する
        find('a[class="login"]').click
        expect(current_path).to eq new_user_session_path
        # "サインインする" 
        fill_in "user[email]", with: @user.email
        fill_in "user[password]", with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # "ページ上部のユーザー名をクリック" 
        click_link("#{@user.nickname}")
        # "マイページに遷移する" 
        expect(current_path).to eq user_path(@user)
        #"自分がお気に入り登録した商品が表示されている(sold out なし)" 
        expect(page).to have_selector ".item-name", text: item.name
        expect(page).not_to have_content("Sold Out!!")  
      end
      it "自分のページにはサインインできる、お気に入り登録した商品が表示されている(購入済み、sold out あり)" do
        # 他のユーザーの商品にお気に入り登録をする。
        favorite = FactoryBot.create(:favorite, user_id: @user.id)
        item = favorite.item
        user2 = FactoryBot.create(:user)
        purchase = FactoryBot.create(:purchase, item_id: item.id, user_id: user2.id)
        # トップページに遷移する
        visit root_path
        # ログインボタンをクリックし、サインインページに移動する
        find('a[class="login"]').click
        expect(current_path).to eq new_user_session_path
        # "サインインする" 
        fill_in "user[email]", with: @user.email
        fill_in "user[password]", with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # "ページ上部のユーザー名をクリック" 
        click_link("#{@user.nickname}")
        # "マイページに遷移する" 
        expect(current_path).to eq user_path(@user)
        #"自分がお気に入り登録した商品が表示されている(sold out あり)" 
        expect(page).to have_selector ".item-name", text: item.name
        expect(page).to have_content("Sold Out!!")     
      end
    end
    context "マイページに入れない時（サインインしていない）" do
      it "ログインしていない状態ではマイページに遷移できない" do
        #トップページに遷移する
        visit root_path
        # "他のユーザーのマイページURLを直接入力する"
        visit user_path(@user)
        # "ログインページにリダイレクトされる" 
        expect(current_path).to eq new_user_session_path
      end
     end
     context "マイページに入れない時（他のユーザーのページ）" do
       it "他のユーザーのページには遷移できない" do
        user2 = FactoryBot.create(:user) 
        # トップページに遷移する
        visit root_path
        # ログインボタンをクリックし、サインインページに移動する
        find('a[class="login"]').click
        expect(current_path).to eq new_user_session_path
        # "@userでサインインする" 
        fill_in "user[email]", with: @user.email
        fill_in "user[password]", with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # "User2のマイページのURLを入力する"
        visit user_path(user2)
        # "トップページに遷移する。" 
        expect(current_path).to eq root_path 
       end
     end
  end
end
