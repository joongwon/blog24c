// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "./Env.res.js";
import * as Pages_Login_Impl from "./Pages_Login_Impl.res.js";
import * as JsxRuntime from "react/jsx-runtime";

function Pages_Login$default(props) {
  return JsxRuntime.jsx(Pages_Login_Impl.make, {
              searchParams: props.searchParams,
              clientId: Env.naverClientId
            });
}

var $$default = Pages_Login$default;

export {
  $$default as default,
}
/* Env Not a pure module */
