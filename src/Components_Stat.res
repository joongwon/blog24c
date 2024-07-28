@react.component
let make = (~icon, ~alt, ~count, ~size="size-5") => {
  if count > 0 {
    <span className="mr-1 text-gray-500 whitespace-nowrap min-w-fit inline-block">
      <img src={icon} alt className={`inline ${size}`} />
      {count->Int.toString->React.string}
    </span>
  } else {
    React.null
  }
}
