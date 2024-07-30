@@directive(`'use client';`)

@react.component
let make = () => {
  React.useEffect(() => {
    Auth.initToken()->Promise.done
    None
  }, [])
  React.null
}
