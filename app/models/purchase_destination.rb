class PurchaseDestination
  include ActiveModel::Model
  attr_accessor :user_id
  attr_accessor :item_id
  attr_accessor :postal_number
  attr_accessor :prefecture_id
  attr_accessor :municipalities
  attr_accessor :address
  attr_accessor :building_name
  attr_accessor :phone_number
  attr_accessor :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_number, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ }
    validates :prefecture_id, numericality: { other_than: 1 }
    validates :municipalities
    validates :address
    validates :phone_number, format: { with: /\A[0-9]{10,11}\z/ }
    validates :token
  end

  def save
    purchase = Purchase.create(user_id: user_id, item_id: item_id)
    destination = Destination.create(postal_number: postal_number, prefecture_id: prefecture_id, municipalities: municipalities, address: address, phone_number: phone_number, purchase_id: purchase.id)
  end

end