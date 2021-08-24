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
    it "出品した商品の商品名がレスポンスに含まれている。" do
      get root_path
      expect(response.body).to include(@item.name)
    end
    it "出品した商品の画像がレスポンスに含まれている。" do
      get root_path
      expect(response.body).to include("img")
    end
    it "購入済の商品はトップページに表示されない（商品名)" do
      destination = FactoryBot.create(:destination)
      purchase = destination.purchase
      item = purchase.item
      get root_path
      expect(response.body).not_to include(item.name)
    end
    it "表示できる商品が存在しない時にはサンプル画像が表示される" do
      purchase = FactoryBot.create(:purchase, item_id: @item.id)
      get root_path
      expect(response.body).to include("商品を出品してね")
      expect(response.body).to include("https://tech-master.s3.amazonaws.com/uploads/curriculums/images/Rails1-4/sample.jpg")
    end
  end
  describe "items#show" do
    it "searchアクションにリクエストを送ると正常にレスポンスが返ってくる" do
      get search_items_path
      expect(response.status).to eq 200
    end
    it "そのままだと検索結果なしになる" do
      get search_items_path
      expect(response.body).to include("『』の検索結果はありませんでした。")
      expect(response.body).not_to include(@item.name)
    end
  end
end
