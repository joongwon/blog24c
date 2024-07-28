@module("pg") external types: 'a = "types"
types["setTypeParser"](types["builtins"]["INT8"], v => Int.fromString(v))
types["setTypeParser"](types["builtins"]["TIMESTAMP"], v => v)

let dbConfig: Pg.Pool.config = {
  connectionString: Env.databaseUrl,
}

let pool = Pg.Pool.make(dbConfig)

let tx = async f => {
  open Pg.Pool
  let client = await pool->connect
  try {
    (await client->PgTyped.Pg.Client.query("BEGIN"))->ignore
    let result = await f(client)
    (await client->PgTyped.Pg.Client.query("COMMIT"))->ignore
    await client->release
    result->Ok
  } catch {
  | e => {
      await client->release
      e->Error
    }
  }
}

let query = async (f, param) => {
  open Pg.Pool
  let client = await pool->connect
  try {
    let result = await client->f(param)
    await client->release
    result->Ok
  } catch {
  | e => {
      await client->release
      e->Error
    }
  }
}

let redisPromise = (
  async () => {
    let client = Redis.make({url: "redis://localhost:6379"})
    await client->Redis.connect
    client
  }
)()

let getRedis = async () => {
  await redisPromise
}
