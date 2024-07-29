@@directive(`'use client'`)

type _t =
  | Loading
  | Error
  | AccessDenied
  | Redirect
  | Login
  | Register({name: string, code: string})

include GlobalState.Make({
  type t = _t
  let initial = () => Loading
})

let initLoginCalled = ref(false)
let initLogin = async () => {
  if initLoginCalled.contents {
    ()
  } else {
    initLoginCalled := true
    let code =
      Webapi.Dom.location
      ->Webapi.Dom.Location.search
      ->Webapi.Url.URLSearchParams.make
      ->Webapi.Url.URLSearchParams.get("code")
    switch code {
    | None => update(Error)
    | Some(code) =>
      let res = await Actions.tryLogin(code)
      switch res {
      | Ok(Register({code, naverName})) => update(Register({name: naverName, code}))
      | Ok(Login(res)) =>
        Auth.update(Auth.LoggedIn(res))
        update(Login)
      | Error(Unauthorized) => update(AccessDenied)
      | Error(InternalServerError) => update(Error)
      }
    }
  }
}

@react.component
let default = (~searchParams) => {
  let from = searchParams["state"]->Option.filter(s => s->String.startsWith("/"))->Option.getOr("/")
  let login = useSync()

  // send login request
  React.useEffect(() => {
    initLogin()->Promise.done
    None
  }, [])

  // routing
  let router = Next.Navigation.useRouter()
  React.useEffect(() => {
    switch login {
    | Login =>
      router->Next.Navigation.Router.replace(from)
      update(Redirect)
    | Register({name, code}) =>
      router->Next.Navigation.Router.replace(
        "/register?name=" ++
        encodeURIComponent(name) ++
        "&code=" ++
        encodeURIComponent(code) ++
        "&from=" ++
        encodeURIComponent(from),
      )
      update(Redirect)
    | _ => ()
    }
    None
  }, (login, from, router))

  // render
  switch login {
  | Loading => <main> {"로그인 중..."->React.string} </main>
  | Login | Register(_) | Redirect => <main> {"리다이렉트 중..."->React.string} </main>
  | AccessDenied =>
    <main>
      <p> {"접근 권한이 없습니다"->React.string} </p>
      <nav>
        <Next.Link href={from}> {"돌아가기"->React.string} </Next.Link>
      </nav>
    </main>
  | Error =>
    <main>
      <p> {"로그인 중 오류가 발생했습니다"->React.string} </p>
      <nav>
        <ul>
          <li>
            <Next.Link href={`/login?from=${encodeURIComponent(from)}`}>
              {"다시 로그인"->React.string}
            </Next.Link>
          </li>
          <li>
            <Next.Link href={from}> {"돌아가기"->React.string} </Next.Link>
          </li>
        </ul>
      </nav>
    </main>
  }
}
