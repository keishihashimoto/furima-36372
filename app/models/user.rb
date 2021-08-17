class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password,
            format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
                      message: 'is Invalid. Alphabet and number must be used together.' }
  validates :nickname, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is Invalid. Input full-width characters.' }
  validates :last_name, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'is Invalid. Input full-width characters.' }
  validates :first_name_reading, presence: true
  validates :last_name_reading, presence: true
  validates :first_name_reading, format: { with: /\A[ァ-ヶ一]+\z/, message: 'is Invalid. Input full-width katakana caracters' }
  validates :last_name_reading, format: { with: /\A[ァ-ヶ一]+\z/, message: 'is Invalid. Input full-width katakana caracters' }
  validates :birth_day, presence: true
end
