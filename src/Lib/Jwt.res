type options = {expiresIn?: string}
@module("jsonwebtoken")
external _sign: ('a, string, options, (Nullable.t<exn>, Nullable.t<string>) => unit) => unit =
  "sign"

let sign = (payload, secret, options) =>
  Promise.make((resolve, _) =>
    _sign(payload, secret, options, (err, token) =>
      switch (err, token) {
      | (Value(err), _) => resolve(Error(err))
      | (_, Value(token)) => resolve(Ok(token))
      | _ => assert(false)
      }
    )
  )
