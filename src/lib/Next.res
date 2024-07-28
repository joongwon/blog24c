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

module Link = {
  @module("next/link") @react.component
  external make: (
    ~href: string,
    ~children: React.element,
    ~className: option<string>=?,
  ) => React.element = "default"
}

module Navigation = {
  // thorws error and never return, but rescript does not support bottom type...
  @moodule("next/navigation")
  external notFound: unit => React.element = "notFound"
}
