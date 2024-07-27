external env: Dict.t<string> = "process.env"

let databaseUrl =
  env
  ->Dict.get("DATABASE_URL")
  ->Option.getExn(~message="DATABASE_URL environment variable is not set")
let redisUrl =
  env->Dict.get("REDIS_URL")->Option.getExn(~message="REDIS_URL environment variable is not set")
let jwtSecret =
  env->Dict.get("JWT_SECRET")->Option.getExn(~message="JWT_SECRET environment variable is not set")
