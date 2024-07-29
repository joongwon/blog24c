@@directive("'use client'")

let authUrl = (clientId, from) => {
  let state = encodeURIComponent(from)
  let host = %raw("window.location.origin")
  let redirectUri = encodeURIComponent(`${host}/login/naver/callback`)
  `https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}&state=${state}`
}

@react.component
let make = (~searchParams, ~clientId) => {
  let auth = Auth.useSync()
  let from = searchParams["from"]->Option.getOr("/")
  let from = from->String.startsWith("/") ? from : "/"
  switch auth {
  | Loading => <main> {"로딩중..."->React.string} </main>
  | LoggedIn(_) =>
    <main>
      <p> {"이미 로그인되어 있습니다"->React.string} </p>
      <Next.Link href={from}> {"돌아가기"->React.string} </Next.Link>
    </main>
  | Anon =>
    <main>
      <h1 className="text-2xl font-bold"> {"로그인"->React.string} </h1>
      <p>
        {"네이버로 로그인하여 일지를 쓰고 반응을 남겨보세요"->React.string}
      </p>
      <a href={authUrl(clientId, from)}>
        <img src="/img/naverLogin.png" alt="네이버로 로그인" width="225" height="60" />
      </a>
    </main>
  }
}
