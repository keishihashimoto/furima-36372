const pay = () => {
  Payjp.setPublicKey(process.env.PUBLIC_KEY)
  const button = document.getElementById("button")
  button.addEventListener("click", (e) => {
    e.preventDefault()
    const chargeForm = document.getElementById("charge-form")
    const formData = new FormData(chargeForm)
    const card = {
      number: formData.get("purchase_destination[card_number]"),
      cvc: formData.get("purchase_destination[cvc]"),
      exp_month: formData.get("purchase_destination[exp_month]"),
      exp_year: `20${formData.get("purchase_destination[exp_year]")}`,
    }
    Payjp.createToken(card, (status, response) => {
      if (status == 200){
        const token = response.id
        const html = `<input value=${token} name="token" type="hidden">`
        document.getElementById("charge-form").insertAdjacentHTML("beforeend", html)
      }
      debugger
      document.getElementById("card-number").removeAttribute("name")
      document.getElementById("card-exp-month").removeAttribute("name")
      document.getElementById("card-exp-year").removeAttribute("name")
      document.getElementById("card-cvc").removeAttribute("name")//
      document.getElementById("charge-form").submit()
    })
  })
}

window.addEventListener("load", pay)