require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe '新規登録' do
    context '新規登録ができる場合' do
      it '適切な情報を入力すれば、新規登録ができる' do
        expect(@user).to be_valid
      end
    end
    context '新規登録ができない場合' do
      it 'nicknameが空では新規登録ができない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'emailが空では新規登録ができない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "メールアドレスに@が含まれていなければ登録ができない" do
        @user.email = "absd12345"
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
      it 'メールアドレスが一意でなければ登録ができない' do
        user = FactoryBot.build(:user)
        user.email = @user.email
        user.save
        @user.valid?
        expect(@user.errors.full_messages).to include('Email has already been taken')
      end
      it 'passwordが空では登録ができない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが５文字以下では登録ができない' do
        @user.password = '123ab'
        @user.password_confirmation = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'passwordが英数字混合でなければ登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is Invalid. Alphabet and number must be used together.')
      end
      it 'passwordが英数字混合でなければ登録できない' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is Invalid. Alphabet and number must be used together.')
      end
      it 'passwordが英数字混合でなければ登録できない' do
        @user.password = '１２３abc'
        @user.password_confirmation = '１２３abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is Invalid. Alphabet and number must be used together.')
      end
      it 'password = password__confirmationでなければ登録ができない' do
        @user.password = '12345a'
        @user.password_confirmation = '12345b'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it '名字がなければ登録ができない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end
      it '名前がなければ登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end
      it '名字と名前は全角（漢字・カタカナ・ひらがな）でなければ登録できない' do
        @user.first_name = 'tanaka@'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name is Invalid. Input full-width characters.')
      end
      it '名字と名前は全角（漢字・カタカナ・ひらがな）でなければ登録できない' do
        @user.last_name = 'tanaka@'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name is Invalid. Input full-width characters.')
      end
      it '読み仮名が空では登録できない' do
        @user.first_name_reading = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name reading can't be blank")
      end
      it '読み仮名が空では登録できない' do
        @user.last_name_reading = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name reading can't be blank")
      end
      it '読み仮名がカタカナでないと登録できない' do
        @user.first_name_reading = 'たろう'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name reading is Invalid. Input full-width katakana caracters')
      end
      it '読み仮名がカタカナでないと登録できない' do
        @user.last_name_reading = 'たろう'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name reading is Invalid. Input full-width katakana caracters')
      end
      it '生年月日が空では登録できない' do
        @user.birth_day = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth day can't be blank")
      end
    end
  end
end
