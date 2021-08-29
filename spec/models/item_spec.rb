require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end
  describe '出品' do
    context '出品できる時' do
      it '正しい情報が入力されていれば出品できる' do
        expect(@item).to be_valid
      end
      it "画像が１枚しかなくても出品できる" do
        @item.images[1] = nil
        expect(@item).to be_valid
      end
    end
    context '出品できない時' do
      it '画像が添付されていなければ出品できない' do
        @item.images = []
        @item.valid?
        expect(@item.errors.full_messages).to include("Images can't be blank")
      end
      it '商品名がなければ出品できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Name can't be blank")
      end
      it '商品名が41文字以上の場合には出品できない' do
        @item.name = Faker::String.random(length: 41)
        @item.valid?
        expect(@item.errors.full_messages).to include('Name is too long (maximum is 40 characters)')
      end
      it '商品の説明がなければ出品できない' do
        @item.description = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Description can't be blank")
      end
      it '説明文が1000文字より多いと出品できない' do
        @item.description = Faker::String.random(length: 1001)
        @item.valid?
        expect(@item.errors.full_messages).to include('Description is too long (maximum is 1000 characters)')
      end
      it 'カテゴリーを選択していないと出品できない' do
        @item.category = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Category can't be blank")
      end
      it 'カテゴリーが---のままでは出品できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Category can't be blank")
      end
      it '商品の状態を選択していないと出品できない' do
        @item.condition = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Condition can't be blank")
      end
      it '商品状態が---のままでは出品できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Condition can't be blank")
      end
      it '発送料の負担者を選択していないと出品できない' do
        @item.postage = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Postage can't be blank")
      end
      it '発送料の負担者が---のままでは出品できない' do
        @item.postage_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Postage can't be blank")
      end
      it '発送元地域を選択していないと出品できない' do
        @item.prefecture = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Prefecture can't be blank")
      end
      it '発送元地域が---のままでは出品できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Prefecture can't be blank")
      end
      it '発送までの日数を選択していないと出品できない' do
        @item.delivery = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Delivery can't be blank")
      end
      it '発送までの日数が---のままでは出品できない' do
        @item.delivery_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("Delivery can't be blank")
      end
      it '価格を入力していないと出品できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end
      it '価格が300円未満では出品できない' do
        @item.price = 200
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be greater than or equal to 300')
      end
      it '価格が10000000円以上では出品できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be less than or equal to 9999999')
      end
      it '価格が全角で入力されている場合には出品できない' do
        @item.price = '１２３０'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
      it '価格が英数字混合で入力されている場合には出品できない' do
        @item.price = '123abc'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
      it '価格が英字のみで入力されている場合には出品できない' do
        @item.price = 'abc'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
      it 'ユーザーと紐づいていなければ出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end
    end
  end
end
