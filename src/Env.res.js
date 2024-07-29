// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Core__Option from "@rescript/core/src/Core__Option.res.js";

var databaseUrl = Core__Option.getExn(process.env["DATABASE_URL"], "DATABASE_URL environment variable is not set");

var redisUrl = Core__Option.getExn(process.env["REDIS_URL"], "REDIS_URL environment variable is not set");

var jwtSecret = Core__Option.getExn(process.env["JWT_SECRET"], "JWT_SECRET environment variable is not set");

var staticUrl = Core__Option.getExn(process.env["STATIC_URL"], "STATIC_URL environment variable is not set");

var naverClientId = Core__Option.getExn(process.env["NAVER_CLIENT_ID"], "NAVER_CLIENT_ID environment variable is not set");

var naverClientSecret = Core__Option.getExn(process.env["NAVER_CLIENT_SECRET"], "NAVER_CLIENT_SECRET environment variable is not set");

export {
  databaseUrl ,
  redisUrl ,
  jwtSecret ,
  staticUrl ,
  naverClientId ,
  naverClientSecret ,
}
/* databaseUrl Not a pure module */
