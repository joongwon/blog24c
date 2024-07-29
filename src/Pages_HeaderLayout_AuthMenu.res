@@directive(`'use client';`)

module Container = {
  @react.component
  let make = (~children) => {
    <menu className="flex space-x-4 items-center"> {children} </menu>
  }
}

@react.component
let make = () => {
  let auth = Auth.useSync()
  let router = Next.Navigation.useRouter()
  let handleLogin = e => {
    e->ReactEvent.Mouse.preventDefault
    let from =
      %raw(
        "window.location.pathname + window.location.search + window.location.hash"
      )->encodeURIComponent
    router->Next.Navigation.Router.push("/login?from=" ++ from)
  }
  switch auth {
  | Loading => <Container> {"사용자 확인중..."->React.string} </Container>
  | LoggedIn(user) =>
    <Container>
      <li> {`${user.profile.name}님 환영합니다`->React.string} </li>
      <li>
        <Next.Link href="/drafts"> {"일지 쓰기"->React.string} </Next.Link>
      </li>
      <li>
        <Next.Link href="/logout"> {"로그아웃"->React.string} </Next.Link>
      </li>
    </Container>
  | Anon =>
    <Container>
      <li>
        <a href="/login" onClick=handleLogin> {"로그인"->React.string} </a>
      </li>
    </Container>
  }
}
