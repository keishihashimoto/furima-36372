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
    validates :postal_number
    validates :prefecture_id
    validates :municipalities
    validates :address
    validates :phone_number
    validates :purchase_id
  end

  def save
    purchase = Purchase.create(user_id: current_user.id, item_id: params[:item_id])
    destination = Destination.create(postal_number: postal_number, prefecture_id: prefecture_id, municipalities: municipalities, address: address, phone_number: phone_number, purchase_id: purchase.id)
  end

end