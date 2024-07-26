%%raw(`
import { types } from 'pg';
types.setTypeParser(types.builtins.INT8, BigInt);
`)

module Pool = {
  type config = {connectionString: string}
  type t
  @module("pg") @new external make: config => t = "Pool"
  type client = PgTyped.Pg.Client.t
  @send external connect: t => promise<client> = "connect"
  @send external end: t => promise<unit> = "end"
  @send external release: client => promise<unit> = "release"
}
