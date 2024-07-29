@@directive(`'use client';`)

include GlobalState.Make({
  type t = float
  let initial = () => Date.now()
})

let timeout = ref(None)

addHook(_ => {
  timeout.contents->Option.map(clearTimeout)->ignore
  // refresh after 1 minute
  timeout := setTimeout(() => {
      update(Date.now())
    }, 60 * 1000)->Some
})

update(Date.now())
