module Headers = {
  module Cookies = {
    type t
    type cookie = {value: string}
    type options = {
      path: string,
      httpOnly: bool,
      sameSite: [#strict],
      maxAge: int,
    }

    @send external get: (t, string) => option<cookie> = "get"
    @send external set: (t, string, string, options) => unit = "set"
  }
  @module("next/headers") external cookies: unit => Cookies.t = "cookies"
}
