@@directive(`'use client';`)

type _t = Loading | Anon | LoggedIn(Actions.loginResult)

include GlobalState.Make({
  type t = _t
  let initial = () => Loading
})

let timeout = ref(None)

addHook(state => {
  timeout.contents->Option.map(clearTimeout)->ignore
  switch state {
  | LoggedIn(_) =>
    // refresh token after 50 minutes
    timeout := setTimeout(() => {
        switch state {
        | LoggedIn(_) =>
          Actions.refresh()
          ->Promise.thenResolve(
            res => {
              let newState = switch res {
              | None => Anon
              | Some(res) => LoggedIn(res)
              }
              update(newState)
            },
          )
          ->Promise.done
        | _ => ()
        }
      }, 50 * 60 * 1000)->Some
  | _ => ()
  }
})

// executed once by InitToken effect to initialize token
let initTokenCalled = ref(false)
let initToken = async () => {
  if !initTokenCalled.contents {
    initTokenCalled := true

    let pathname: string = %raw(`window.location.pathname`)
    if pathname === "/login/naver/callback" {
      update(Anon)
    } else {
      let res = await Actions.refresh()
      let newState = switch res {
      | None => Anon
      | Some(res) => LoggedIn(res)
      }
      update(newState)
    }
  }
}
