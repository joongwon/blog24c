'use client';
// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Auth from "./Auth.res.js";
import * as React from "react";

function InitToken(props) {
  React.useEffect((function () {
          Auth.initToken();
        }), []);
  return null;
}

var make = InitToken;

export {
  make ,
}
/* Auth Not a pure module */
