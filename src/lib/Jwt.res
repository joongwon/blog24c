type options = {expiresIn?: string}
@module("jsonwebtoken")
external _sign: ('a, string, options, (option<exn>, option<string>) => unit) => unit = "sign"

let sign = (payload, secret, options) =>
  Promise.make((resolve, _) =>
    _sign(payload, secret, options, (err, token) =>
      switch (err, token) {
      | (Some(err), _) => resolve(Error(err))
      | (_, Some(token)) => resolve(Ok(token))
      | _ => assert(false)
      }
    )
  )
