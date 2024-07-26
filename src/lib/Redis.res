type t
type config = {url: string}
type setOptions = {ex?: int}
@module("redis") external make: config => t = "createClient"
@send external connect: t => promise<unit> = "connect"
@send external getDel: (t, string) => promise<option<string>> = "getDel"
@send external set: (t, string, string, setOptions) => promise<unit> = "set"
