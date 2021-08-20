class PurchaseDestination
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_number, :prefecture_id, :municipalities, :address, :building_name, :phone_number,
                :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_number, format: { with: /\A\d{3}-\d{4}\z/ }
    validates :prefecture_id, numericality: { other_than: 1 }
    validates :municipalities
    validates :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/ }
    validates :token
  end

  def save
    purchase = Purchase.create(user_id: user_id, item_id: item_id)
    destination = Destination.create(postal_number: postal_number, prefecture_id: prefecture_id, municipalities: municipalities,
                                     address: address, phone_number: phone_number, purchase_id: purchase.id)
  end
end
