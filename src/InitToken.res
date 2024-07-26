@@directive(`'use client';`)

@react.component
let make = () => {
  React.useInsertionEffect(() => {
    Auth.initToken()->Promise.done
    None
  }, [])
  React.null
}
