class Destination < ApplicationRecord
  with_options presence: true do
    validates :postal_number
    validates :prefecture_id
    validates :municipalities
    validates :address
    validates :phone_number
  end
  belongs_to :purchase
  extend ActiveBase::Associations::ActiveRecordExtensions
  belongs_to :prefecture
end
