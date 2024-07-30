type profile = {id: string, name: string, role: [#admin | #user]}
type loginResult = {
  accessToken: string,
  profile: profile,
}
type tryLoginSuccess =
  | Register({code: string, naverName: string})
  | Login(loginResult)
type tryLoginError =
  | Unauthorized
  | InternalServerError

let refresh: unit => promise<option<loginResult>>
let tryLogin: string => promise<result<tryLoginSuccess, tryLoginError>>
