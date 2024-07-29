type t
type config = {url: string}
type setOptions = {ex?: int}
@module("redis") external make: config => t = "createClient"
@send external connect: t => promise<unit> = "connect"
@send external _getDel: (t, string) => promise<Null.t<string>> = "getDel"
@send external set: (t, string, string, setOptions) => promise<unit> = "set"

let getDel = async (client, key) => {
  let r = await client->_getDel(key)
  r->Null.toOption
}
