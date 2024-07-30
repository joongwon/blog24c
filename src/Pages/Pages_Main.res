@jsx.component
let default = async () => {
  let title = "환영합니다"
  <article>
    <h1> {title->React.string} </h1>
  </article>
}
