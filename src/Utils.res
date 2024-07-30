module Result = {
  include Result

  let await_ = async res =>
    switch res {
    | Ok(res) => Ok(await res)
    | Error(err) => Error(err)
    }
  let toOption = result => result->Result.mapOr(None, x => Some(x))
  let flatten = result => result->Result.flatMap(x => x)
}

module Option = {
  include Option

  let await_ = async option =>
    switch option {
    | None => None
    | Some(value) => Some(await value)
    }
  let flatten = option => option->Option.flatMap(x => x)
  let flattenResult = option => option->Option.flatMap(Result.toOption)
}
