// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml_option from "rescript/lib/es6/caml_option.js";

async function getDel(client, key) {
  return Caml_option.null_to_opt(await client.getDel(key));
}

export {
  getDel ,
}
/* No side effect */
