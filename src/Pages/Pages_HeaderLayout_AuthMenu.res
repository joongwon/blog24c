@@directive(`'use client';`)

module Container = {
  @react.component
  let make = (~children) => {
    <menu className="flex items-center"> {children} </menu>
  }
}

module Item = {
  @react.component
  let make = (~children) => {
    <li className="before:content-['·'] first:before:content-none before:mx-1"> {children} </li>
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
  let handleLogout = e => {
    e->ReactEvent.Mouse.preventDefault
    //Auth.logout()
  }
  switch auth {
  | Loading =>
    <Container>
      <Item> {"사용자 확인중..."->React.string} </Item>
    </Container>
  | LoggedIn(user) =>
    <Container>
      <Item> {`${user.profile.name}님 환영합니다`->React.string} </Item>
      <Item>
        <Next.Link href="/drafts"> {"일지 쓰기"->React.string} </Next.Link>
      </Item>
      <Item>
        <a href="/logout" onClick=handleLogout> {"로그아웃"->React.string} </a>
      </Item>
    </Container>
  | Anon =>
    <Container>
      <Item>
        <a href="/login" onClick=handleLogin> {"로그인"->React.string} </a>
      </Item>
    </Container>
  }
}
