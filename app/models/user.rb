class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password,
            format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
                      message: 'is Invalid. Alphabet and number must be used together.' }
  with_options presence: true do
    validates :nickname
    validates :birth_day
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is Invalid. Input full-width characters.' } do
      validates :first_name
      validates :last_name
    end
    with_options format: { with: /\A[ァ-ヶ一]+\z/, message: 'is Invalid. Input full-width katakana caracters' } do
      validates :first_name_reading
      validates :last_name_reading
    end
  end
  has_many :items
  has_many :items
end
