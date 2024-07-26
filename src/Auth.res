@@directive(`'use client';`)

type loggedIn = Actions.loginResult
type t =
  | Loading
  | Anon
  | LoggedIn(loggedIn)

let state = ref(Loading)
let listeners = Set.make()

let use = () =>
  React.useSyncExternalStore(
    ~subscribe=listener => {
      listeners->Set.add(listener)
      () => listeners->Set.delete(listener)->ignore
    },
    ~getSnapshot=() => state.contents,
  )

let timeout = ref(None)

let update = (newState: t) => {
  state := newState

  timeout.contents->Option.map(clearTimeout)->ignore
  switch state.contents {
  | Loading | Anon => ()
  | LoggedIn(_) =>
    // refresh token after 50 minutes
    timeout := setTimeout(() => {
        switch state.contents {
        | Loading | Anon => ()
        | LoggedIn(_) =>
          Actions.refresh()
          ->Promise.thenResolve(res => {
            switch res {
            | None => state := Anon
            | Some(res) => state := LoggedIn(res)
            }
          })
          ->Promise.done
        }
      }, 50 * 60 * 1000)->Some
  }

  listeners->Set.forEach(listener => listener())
}

// executed once by InitToken effect to initialize token
let initTokenCalled = ref(false)
let initToken = async () => {
  if !initTokenCalled.contents {
    initTokenCalled := true

    let pathname: string = %raw(`window.location.pathname`)
    if pathname === "/login/naver/callback" {
      state := Anon
    } else {
      let res = await Actions.refresh()
      switch res {
      | None => state := Anon
      | Some(res) => state := LoggedIn(res)
      }
    }
  }
}
