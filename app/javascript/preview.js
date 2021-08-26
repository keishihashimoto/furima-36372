const setPreview = () => {
  const imageList = document.getElementById("image-list")
  const itemImage = document.getElementById("item-image")
  itemImage.addEventListener("change", (e) => {
    const file = e.target.files[0]
    const url = window.URL.createObjectURL(file)
    const parent = document.createElement('div')
    const child = document.createElement('img')
    child.setAttribute("src", url)
    parent.appendChild(child)
    document.getElementById("image-list").appendChild(parent)
  })
}

window.addEventListener("load", setPreview)