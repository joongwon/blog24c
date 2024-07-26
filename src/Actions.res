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

type profile = {id: string, name: string, role: [#admin | #user]}

type loginResult = {
  accessToken: string,
  profile: profile,
}

let login = async (~userId) => {
  let profile =
    await %sql.one(`SELECT id, name, role FROM users WHERE id = :id!`)->Db.query({id: userId})
  switch profile {
  | Error(err) =>
    Console.log(err)
    Error("Failed to fetch user profile")
  | Ok(None) => Error("User not found")
  | Ok(Some(profile)) =>
    switch await Jwt.sign({"id": userId}, Env.jwtSecret, {expiresIn: "1h"}) {
    | Error(err) =>
      Console.log(err)
      Error("Failed to sign token")
    | Ok(accessToken) =>
      let refreshToken = "refreshToken:" ++ randomUUID()
      let redis = await Db.getRedis()
      await redis->Redis.set(refreshToken, userId, {ex: 7 * 24 * 60 * 60})
      setRefreshToken(refreshToken)
      Ok({accessToken, profile: {id: profile.id, name: profile.name, role: profile.role}})
    }
  }
}

let refresh = async () => {
  switch getRefreshToken() {
  | None => None
  | Some(refreshToken) =>
    let redis = await Db.getRedis()
    switch await redis->Redis.getDel("refreshToken:" ++ refreshToken) {
    | None => None
    | Some(userId) =>
      let res = await login(~userId)
      switch res {
      | Error(err) =>
        Console.log(err)
        None
      | Ok(res) => Some(res)
      }
    }
  }
}
