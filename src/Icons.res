module type S = {
  let code: int
}

module Make = (S: S) => {
  @react.component
  let make = (~className="") => {
    <span className={"material-symbols-outlined " ++ className}>
      {String.fromCharCode(S.code)->React.string}
    </span>
  }
}

module Comment = Make({
  let code = 0xe0b9
})
module Visibility = Make({
  let code = 0xe8f4
})
module Favorite = Make({
  let code = 0xe87d
})
module ArrowUp = Make({
  let code = 0xe316
})
module ArrowDown = Make({
  let code = 0xe313
})
module ArrowRight = Make({
  let code = 0xe315
})
module Menu = Make({
  let code = 0xe5d2
})
module Close = Make({
  let code = 0xe5cd
})
module GoToTop = Make({
  let code = 0xe5d8
})
module More = Make({
  let code = 0xe5d3
})
module Delete = Make({
  let code = 0xe872
})
