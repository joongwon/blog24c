@@directive(`'use server';`)

open! Utils

@module("crypto") external randomUUID: unit => string = "randomUUID"

type profile = {id: string, name: string, role: [#admin | #user]}

type loginResult = {
  accessToken: string,
  profile: profile,
}
// 쿠키에 저장된 refresh token을 가져오는 함수
let getRefreshToken = () => {
  Next.Headers.cookies()
  ->Next.Headers.Cookies.get("refreshToken")
  ->Option.map(cookie => cookie.value)
}

// 쿠키에 refresh token을 저장하는 함수
let setRefreshToken = refreshToken => {
  Next.Headers.cookies()->Next.Headers.Cookies.set(
    "refreshToken",
    refreshToken,
    {
      path: "/",
      httpOnly: true,
      sameSite: #strict,
      maxAge: 7 * 24 * 60 * 60,
    },
  )
}

let deleteRefreshToken = () => {
  Next.Headers.cookies()->Next.Headers.Cookies.set(
    "refreshToken",
    "",
    {
      path: "/",
      httpOnly: true,
      sameSite: #strict,
      maxAge: 0,
    },
  )
}

let login = async profile => {
  let token = await Jwt.sign({"id": profile.id}, Env.jwtSecret, {expiresIn: "1h"})
  await token
  ->Result.map(async accessToken => {
    let refreshToken = "refreshToken:" ++ randomUUID()
    let redis = await Db.getRedis()
    await redis->Redis.set(refreshToken, profile.id, {ex: 7 * 24 * 60 * 60})
    setRefreshToken(refreshToken)
    {accessToken, profile: (profile :> profile)}
  })
  ->Result.await_
}

let refresh = async () => {
  let refreshToken = getRefreshToken()
  let userId =
    await refreshToken
    ->Option.map(async refreshToken => {
      let redis = await Db.getRedis()
      await redis->Redis.getDel(refreshToken)
    })
    ->Option.await_
    ->Promise.thenResolve(Option.flatten)

  let profile =
    await userId
    ->Option.map(userId =>
      %sql.one(`
        /* @name GetUserById */
        SELECT id, name, role FROM users WHERE id = :id!
      `)->Db.query({
        id: userId,
      })
    )
    ->Option.await_
    ->Promise.thenResolve(Option.flatten)
  let res =
    await profile
    ->Option.map(profile => login((profile :> profile)))
    ->Option.await_
    ->Promise.thenResolve(Option.flattenResult)
  res
}

type tryLoginSuccess =
  | Register({code: string, naverName: string})
  | Login(loginResult)

type tryLoginError = Unauthorized

let tryLogin = async code => {
  let getNaverAccessToken = async () => {
    // 네이버 access token을 받아오기
    let client_id = Env.naverClientId
    let client_secret = Env.naverClientSecret
    let res = await Webapi.Fetch.fetchWithInit(
      "https://nid.naver.com/oauth2.0/token",
      Webapi.Fetch.RequestInit.make(
        ~method_=Webapi.Fetch.Post,
        ~headers=Webapi.Fetch.HeadersInit.make({
          "Content-Type": "application/x-www-form-urlencoded",
        }),
        ~body=Webapi.Fetch.BodyInit.make(
          Webapi.Url.URLSearchParams.makeWithArray([
            ("grant_type", "authorization_code"),
            ("code", code),
            ("state", "state"),
            ("client_id", client_id),
            ("client_secret", client_secret),
          ])->Webapi.Url.URLSearchParams.toString,
        ),
        (),
      ),
    )
    let data = await res->Webapi.Fetch.Response.json
    data
    ->Js.Json.decodeObject
    ->Option.flatMap(obj => obj->Js.Dict.get("access_token"))
    ->Option.flatMap(obj => obj->Js.Json.decodeString)
    ->Option.mapOr(Error(Unauthorized), x => Ok(x))
  }

  let getNaverProfile = async accessToken => {
    // 네이버 프로필을 받아오기
    let data = await Webapi.Fetch.fetchWithInit(
      "https://openapi.naver.com/v1/nid/me",
      Webapi.Fetch.RequestInit.make(
        ~headers=Webapi.Fetch.HeadersInit.make({
          "Authorization": "Bearer " ++ accessToken,
        }),
        (),
      ),
    )->Promise.then(Webapi.Fetch.Response.json)
    let response =
      data
      ->Js.Json.decodeObject
      ->Option.flatMap(obj => obj->Js.Dict.get("response"))
      ->Option.flatMap(obj => obj->Js.Json.decodeObject)
    let naverId =
      response
      ->Option.flatMap(obj => obj->Js.Dict.get("id"))
      ->Option.flatMap(obj => obj->Js.Json.decodeString)
    let naverName =
      response
      ->Option.flatMap(obj => obj->Js.Dict.get("nickname"))
      ->Option.flatMap(obj => obj->Js.Json.decodeString)
      ->Option.getOr("")

    naverId->Option.mapOr(Error(Unauthorized), x => Ok((x, naverName)))
  }

  let loginOrRegister = async (profile, naverId, naverName) => {
    switch profile {
    | Some(profile) =>
      let loginResult = await login(profile)->Promise.thenResolve(Result.getExn)
      Login(loginResult)
    | None =>
      let redis = await Db.getRedis()
      let registerCode = "registerCode:" ++ randomUUID()
      await redis->Redis.set(registerCode, naverId, {ex: 10 * 60})
      Register({code: registerCode, naverName})
    }
  }

  let accessToken = await getNaverAccessToken()
  let naverProfile =
    await accessToken
    ->Result.map(getNaverProfile)
    ->Result.await_
    ->Promise.thenResolve(Result.flatten)
  await naverProfile
  ->Result.map(async ((naverId, naverName)) => {
    let profile = await %sql.one(`
        /* @name GetUserByNaverId */
        SELECT id, name, role FROM users WHERE naver_id = :naverId!
      `)->Db.query({
      naverId: naverId,
    })

    let res = await loginOrRegister((profile :> option<profile>), naverId, naverName)
    res
  })
  ->Result.await_
}

let logout = async () => {
  let refreshToken = getRefreshToken()
  deleteRefreshToken()
  await refreshToken
  ->Option.map(async refreshToken => {
    let redis = await Db.getRedis()
    await redis->Redis.del(refreshToken)
  })
  ->Option.await_
  ->Promise.thenResolve(ignore)
}
