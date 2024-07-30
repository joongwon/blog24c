@@directive(`'use client'`)

type error
external toJsError: error => Js.Exn.t = "%identity"
@get external digest: error => option<string> = "digest"

@react.component
let default = (~error, ~reset: unit => unit) => {
  <main>
    <h1> {"알 수 없는 오류!"->React.string} </h1>
    <button onClick={_ => reset()}> {"다시 시도"->React.string} </button>
    <p>
      {"오류가 계속되면 아래 내용을 관리자에게 문의하세요"->React.string}
    </p>
    <p> {error->toJsError->Js.Exn.message->Option.getOr("")->React.string} </p>
    <p> {`digest: ${error->digest->Option.getOr("")}`->React.string} </p>
  </main>
}
