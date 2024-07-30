@react.component
let make = (~icon, ~count) => {
  if count > 0 {
    <span className="mr-1 whitespace-nowrap min-w-fit inline-block">
      icon
      {count->Int.toString->React.string}
    </span>
  } else {
    React.null
  }
}
