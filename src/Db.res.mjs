// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Pg from "pg";
import * as Env from "./Env.res.mjs";
import * as Redis from "redis";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

var dbConfig = {
  connectionString: Env.databaseUrl
};

var pool = new Pg.Pool(dbConfig);

async function tx(f) {
  var client = await pool.connect();
  try {
    await client.query("BEGIN");
    var result = await f(client);
    await client.query("COMMIT");
    await client.release();
    return {
            TAG: "Ok",
            _0: result
          };
  }
  catch (raw_e){
    var e = Caml_js_exceptions.internalToOCamlException(raw_e);
    await client.release();
    return {
            TAG: "Error",
            _0: e
          };
  }
}

async function query(f, param) {
  var client = await pool.connect();
  try {
    var result = await f(client, param);
    await client.release();
    return {
            TAG: "Ok",
            _0: result
          };
  }
  catch (raw_e){
    var e = Caml_js_exceptions.internalToOCamlException(raw_e);
    await client.release();
    return {
            TAG: "Error",
            _0: e
          };
  }
}

var redisPromise = (async function () {
      var client = Redis.createClient({
            url: "redis://localhost:6379"
          });
      await client.connect();
      return client;
    })();

async function getRedis() {
  return await redisPromise;
}

export {
  dbConfig ,
  pool ,
  tx ,
  query ,
  redisPromise ,
  getRedis ,
}
/* pool Not a pure module */