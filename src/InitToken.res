@@directive(`'use client';`)

@react.component
let make = () => {
  React.useEffect0(() => {
    Auth.initToken()->Promise.done
    None
  })
  React.null
}
