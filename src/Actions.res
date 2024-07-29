@@directive(`'use server';`)

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

@module("crypto") external randomUUID: unit => string = "randomUUID"

let resultAwait = async res =>
  switch res {
  | Ok(res) => Ok(await res)
  | Error(err) => Error(err)
  }

type profile = {id: string, name: string, role: [#admin | #user]}

type loginResult = {
  accessToken: string,
  profile: profile,
}
%%private(
  let getUserById = async id => {
    await %sql.one(`/* @name GetUserById */ SELECT id, name, role FROM users WHERE id = :id!`)->Db.query({
      id: id,
    })
  }
  let getUserByNaverId = async naverId => {
    await %sql.one(`/* @name GetUserByNaverId */ SELECT id, name, role FROM users WHERE naver_id = :naverId!`)->Db.query({
      naverId: naverId,
    })
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
    ->resultAwait
  }
)

let optionAwait = async option =>
  switch option {
  | None => None
  | Some(value) => Some(await value)
  }

let optionFlatten = option => option->Option.flatMap(x => x)
let resultToOption = result => result->Result.mapOr(None, x => Some(x))
let optionResultFlatten = option => option->Option.flatMap(resultToOption)

let refresh = async () => {
  let refreshToken = getRefreshToken()
  let userId =
    await refreshToken
    ->Option.map(async refreshToken => {
      let redis = await Db.getRedis()
      await redis->Redis.getDel(refreshToken)
    })
    ->optionAwait
    ->Promise.thenResolve(optionFlatten)
  let profile =
    await userId
    ->Option.map(getUserById)
    ->optionAwait
    ->Promise.thenResolve(optionResultFlatten)
    ->Promise.thenResolve(optionFlatten)
  let res =
    await profile
    ->Option.map(profile => login((profile :> profile)))
    ->optionAwait
    ->Promise.thenResolve(optionResultFlatten)
  res
}

type tryLoginResult =
  | Register({code: string, naverName: string})
  | Login(loginResult)

let tryLogin = async code => {
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
  let access_token =
    data
    ->Js.Json.decodeObject
    ->Option.flatMap(obj => obj->Js.Dict.get("access_token"))
    ->Option.flatMap(obj => obj->Js.Json.decodeString)
    ->Option.getExn(~message=`${__LOC__}: access_token not found`)

  // 네이버 프로필을 받아오기
  let data = await Webapi.Fetch.fetchWithInit(
    "https://openapi.naver.com/v1/nid/me",
    Webapi.Fetch.RequestInit.make(
      ~headers=Webapi.Fetch.HeadersInit.make({
        "Authorization": "Bearer " ++ access_token,
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
    ->Option.getExn(~message=`${__LOC__}: naverId not found`)
  let naverName =
    response
    ->Option.flatMap(obj => obj->Js.Dict.get("nickname"))
    ->Option.flatMap(obj => obj->Js.Json.decodeString)
    ->Option.getOr("")

  let profile = await getUserByNaverId(naverId)->Promise.thenResolve(Result.getExn)
  switch profile {
  | Some(profile) =>
    let loginResult = await login((profile :> profile))->Promise.thenResolve(Result.getExn)
    Login(loginResult)
  | None =>
    let redis = await Db.getRedis()
    let registerCode = "registerCode:" ++ randomUUID()
    Console.log2("set registerCode", registerCode)
    await redis->Redis.set(registerCode, naverId, {ex: 10 * 60})
    Register({code: registerCode, naverName})
  }
}
