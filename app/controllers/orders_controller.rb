class OrdersController < ApplicationController
  def index
    @item = Item.find(params[:item_id])
    @purchase_destination = PurchaseDestination.new
  end

  def create
    @item = Item.find(params[:item_id])
    @purchasedestination = PurchaseDestination.new(purchase_params)
    if @purchase_destination.valid?
      Payjp.api_key = "sk_test_85b5d675e2025f1f099e2730"
      Payjp::charge.create(
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
    params.require(:purchase_destination).permit(:postal_number, :prefecture_id, :municipalitiesi, :address, :building_name, :phone_number).merge(item_id: params[:item_id], token: params[:token])
  end

end
