// Generated by ReScript, PLEASE EDIT WITH CARE

import * as JsxRuntime from "react/jsx-runtime";

function Components_Stat(props) {
  var count = props.count;
  if (count > 0) {
    return JsxRuntime.jsxs("span", {
                children: [
                  props.icon,
                  count.toString()
                ],
                className: "mr-1 text-neutral-500 whitespace-nowrap min-w-fit inline-block"
              });
  } else {
    return null;
  }
}

var make = Components_Stat;

export {
  make ,
}
/* react/jsx-runtime Not a pure module */