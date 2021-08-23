class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  def index
    @items = Item.all.order(created_at: 'DESC')
    @purchases = set_purchases
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    redirect_to root_path if current_user.id != @item.user.id || !@item.purchase.nil?
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    if current_user.id == @item.user.id
      @item.destroy
      redirect_to root_path
    else
      redirect_to action: :show
    end
  end

  def search
    @items = Item.search(params[:search])
    @message = set_message
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :description, :category_id, :condition_id, :postage_id, :prefecture_id,
                                 :delivery_id, :price).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_message
    if @items == []
      "『#{params[:search]}』の検索結果はありませんでした。"
    else
      set_purchases
      if @items.length == @purchases.length
        "『#{params[:search]}』に関する商品は全て販売済です。"
      else
        "『#{params[:search]}』の検索結果"
      end
    end
  end

  def set_purchases
    @purchases = []
    @items.each do |item|
      if item.purchase != nil
        @purchases << item.purchase
      end
    end
    return @purchases
  end
end
