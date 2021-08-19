const pay = () => {
  Payjp.setPublicKey("pk_test_d7e8cfb4475936c66faa63b0")
  const button = document.getElementById("button")
  button.addEventListener("click", function(e){
    e.preventDefault()
    const chargeForm = document.getElementById("charge-form")
    const formDate = new FormData(chargeForm)
    const card = {
      number: formDate.get(purchase_destination[card_number]),
      exp_month: formDate.get(purchase_destination[card_exp_month]),
      exp_year: formDate.get(purchase_destination[card_exp_year]),
      cvc: formDate.get(purchase_destination[cvc]),
    }
    Payjp.createToken(card, (status, response) => {
      if (status == 200){
        const token = response.id
      }
      const html = `<input value=${token} name="token">`
      chargeForm.insertAdjacentHTML("beforeend", html)
      document.getElementById("card-number").removeAttribute("name")
      document.getElementById("card-exp-month").removeAttribute("name")
      document.getElementById("card-exp-year").removeAttribute("name")
      document.getElementById("card-cvc").removeAttribute("name")
      chargeForm.submit()
    })
  })
}

window.addEventListener("load", pay)