external env: {..} = "process.env"

let databaseUrl = env["DATABASE_URL"]->Option.getExn("DATABASE_URL environment variable is not set")
let redisUrl = env["REDIS_URL"]->Option.getExn("REDIS_URL environment variable is not set")
let jwtSecret = env["JWT_SECRET"]->Option.getExn("JWT_SECRET environment variable is not set")
