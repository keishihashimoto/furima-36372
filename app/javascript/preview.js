const setPreview = () => {
  const imageList = document.getElementById("image-list")
  const itemImage = document.getElementById("item-image")

  // 画像をHTML要素に埋め込んで表示する処理を切り出し
  const createImageHTML = (url) => {
    // 画像を表示するためのHTML要素を生成
    const parent = document.createElement('div')
    parent.setAttribute("class", "parent")
    const child = document.createElement('img')
    child.setAttribute("src", url)
    parent.appendChild(child)
    // 生成したHTML要素をビューに追加
    document.getElementById("image-list").appendChild(parent)
  }

  itemImage.addEventListener("change", (e) => {
    // 添付ファイルのURLを生成
    let file = e.target.files[0]
    let url = window.URL.createObjectURL(file)
    // 画像をプレビュー表示
    createImageHTML(url)
    // 2枚目の画像を選択するためのフォームを作成
    let imageNum = document.querySelectorAll(".parent")// 既に表示されている画像の枚数を取得
    const html = `<input type="file" name="item[images][]" id="item-image-${imageNum}">`// 既に表示されている画像の枚数をidに付与
    document.getElementById("click-upload").insertAdjacentHTML("beforeend", html)
    // ２つ目の画像投稿フォームをイベント発火の対象に指定
    document.getElementById(`item-image-${imageNum}`).addEventListener("change", (e) => {
      // 添付ファイルのURLを生成
      file = e.target.files[0]
      url = window.URL.createObjectURL(file)
      // 画像を表示するためのURLを作成し、ビューに追加
      createImageHTML(url)
    })
  })
}

window.addEventListener("load", setPreview)