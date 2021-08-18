// 販売手数料を<span id='add-tax-price'></span>円、に、販売利益を<span id='profit'></span>円、に表示する。
// 上記に関しては、価格：<%= f.text_field :price, class:"price-input", id:"item-price", placeholder:"例）300" %>をもとに計算

const calcProfit = () => {
  const taxPriceArea = document.getElementById("add-tax-price")
  const profitArea = document.getElementById("profit")
  const itemPriceArea = document.getElementById("item-price")
  
  itemPriceArea.addEventListener("keyup", function(){
    const itemPrice = itemPriceArea.value
    taxPriceArea.innerHTML = itemPrice * 0.1
    profitArea.innerHTML = itemPrice * 0.9
  })
}

window.addEventListener("load", calcProfit)