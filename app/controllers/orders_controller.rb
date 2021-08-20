class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    set_item
    redirect_to root_path if current_user.id == @item.user.id
    @purchase_destination = PurchaseDestination.new
  end

  def create
    set_item
    @purchase_destination = PurchaseDestination.new(purchase_params)
    if @purchase_destination.valid?
      Payjp.api_key = "sk_test_85b5d675e2025f1f099e2730"
      binding.pry
      Payjp::Charge.create(
        amount: @item.price,
        card: purchase_params[:token],
        currency: "jpy"
      )
      @purchase_destination.save
      redirect_to root_path
    else
      render :index
    end
  end

  private
  def purchase_params
    params.require(:purchase_destination).permit(:postal_number, :prefecture_id, :municipalities, :address, :building_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

end
