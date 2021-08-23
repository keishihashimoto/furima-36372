require 'rails_helper'

RSpec.describe "Items", type: :request do
  before do
    @item = FactoryBot.create(:item)
    sleep 0.1
  end

  describe "items#indexの単体テスト" do
    it "indexアクションにリクエストを送ると正常にレスポンスが帰ってくる" do
      get root_path
      expect(response.status).to eq(200)
    end
    it "出品した商品がレスポンスに含まれている。" do
      get root_path
      expect(response.body).to include(@item.name)
    end
    it "購入済の商品はトップページに表示されない" do
      @user = FactoryBot.create(:user)
      @purchase_destination = FactoryBot(:purchase_destination, item_id: @item.id, user_id: @user.id)
      get root_path
      expect(response.body).not_to include(@item.text)
    end
    it "表示できる商品が存在しない時にはサンプル画像が表示される" do
      get root_path
      expect(response.body).to include("商品を出品してね")
    end
  end
end
