external env: Dict.t<string> = "process.env"

let databaseUrl =
  env
  ->Dict.get("DATABASE_URL")
  ->Option.getExn(~message="DATABASE_URL environment variable is not set")
let redisUrl =
  env->Dict.get("REDIS_URL")->Option.getExn(~message="REDIS_URL environment variable is not set")
let jwtSecret =
  env->Dict.get("JWT_SECRET")->Option.getExn(~message="JWT_SECRET environment variable is not set")
let staticUrl =
  env->Dict.get("STATIC_URL")->Option.getExn(~message="STATIC_URL environment variable is not set")
let naverClientId =
  env
  ->Dict.get("NAVER_CLIENT_ID")
  ->Option.getExn(~message="NAVER_CLIENT_ID environment variable is not set")
let naverClientSecret =
  env
  ->Dict.get("NAVER_CLIENT_SECRET")
  ->Option.getExn(~message="NAVER_CLIENT_SECRET environment variable is not set")
