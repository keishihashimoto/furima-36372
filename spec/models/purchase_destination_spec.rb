require 'rails_helper'

RSpec.describe PurchaseDestination, type: :model do
  before do
    @item = FactoryBot.create(:item)
    @user = @item.user
    @purchase_destination = FactoryBot.build(:purchase_destination, item_id: @item.id, user_id: @user.id)
    sleep 0.1
  end
  describe '購入の単体テストコード' do
    context '購入ができる時' do
      it '正しく情報が入力されれば購入ができる' do
        expect(@purchase_destination).to be_valid
      end
      it '建物名が空欄でも購入ができる' do
        @purchase_destination.building_name = ''
        expect(@purchase_destination).to be_valid
      end
      it '電話番号が10桁の場合でも登録ができる' do
        @purchase_destination.phone_number = Faker::Number.leading_zero_number(digits: 10)
        expect(@purchase_destination).to be_valid
      end
    end
    context '購入ができないとき' do
      it '郵便番号が空欄だと購入できない' do
        @purchase_destination.postal_number = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Postal number can't be blank")
      end
      it '郵便番号が数字のみ、ハイフンなしだと購入できない' do
        @purchase_destination.postal_number = '1234567'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Postal number is invalid')
      end
      it '郵便番号のハイフンの位置が4文字目以外だと購入できない' do
        @purchase_destination.postal_number = '1234-567'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Postal number is invalid')
      end
      it '郵便番号のハイフンの位置が後ろから5文字目以外だと購入できない' do
        @purchase_destination.postal_number = '123-456789'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Postal number is invalid')
      end
      it '都道府県が空欄だと購入できない' do
        @purchase_destination.prefecture_id = nil
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Prefecture can't be blank")
      end
      it '都道府県を選択していない状態だと購入できない' do
        @purchase_destination.prefecture_id = 1
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Prefecture must be other than 1')
      end
      it '市区町村が空欄だと購入できない' do
        @purchase_destination.municipalities = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Municipalities can't be blank")
      end
      it '番地が空欄だと購入できない' do
        @purchase_destination.address = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Address can't be blank")
      end
      it '電話番号が空欄だと購入できない' do
        @purchase_destination.phone_number = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Phone number can't be blank")
      end
      it '電話番号が全角の場合には購入ができない' do
        @purchase_destination.phone_number = '０９０００００１２３４'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号に数字以外を含む場合には購入ができない' do
        @purchase_destination.phone_number = '090-0000-1234'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号が10桁未満の場合には購入ができない' do
        @purchase_destination.phone_number = '012345678'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Phone number is invalid')
      end
      it '電話番号が12桁以上の場合には購入ができない' do
        @purchase_destination.phone_number = '012345678901'
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include('Phone number is invalid')
      end
      it 'ユーザーが紐づいていない場合には購入ができない' do
        @purchase_destination.user_id = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("User can't be blank")
      end
      it '商品が紐づいていない場合には購入ができない' do
        @purchase_destination.item_id = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Item can't be blank")
      end
      it 'tokenがない場合には購入ができない' do
        @purchase_destination.token = ''
        @purchase_destination.valid?
        expect(@purchase_destination.errors.full_messages).to include("Token can't be blank")
      end
    end
  end
end
