// Generated by ReScript, PLEASE EDIT WITH CARE

import Link from "next/link";
import * as JsxRuntime from "react/jsx-runtime";
import * as Pages_HeaderLayout_Header from "./Pages_HeaderLayout_Header.res.js";
import * as Pages_HeaderLayout_NavMenu from "./Pages_HeaderLayout_NavMenu.res.js";
import * as Pages_HeaderLayout_AuthMenu from "./Pages_HeaderLayout_AuthMenu.res.js";

function Pages_HeaderLayout$default(props) {
  return JsxRuntime.jsxs("body", {
              children: [
                JsxRuntime.jsxs(Pages_HeaderLayout_Header.make, {
                      children: [
                        JsxRuntime.jsx(Link, {
                              href: "/",
                              children: "왼손잡이해방연대 아지트",
                              className: "text-2xl font-bold"
                            }),
                        JsxRuntime.jsx(Pages_HeaderLayout_AuthMenu.make, {})
                      ]
                    }),
                JsxRuntime.jsxs("div", {
                      children: [
                        JsxRuntime.jsx(Pages_HeaderLayout_NavMenu.make, {}),
                        props.children
                      ],
                      className: "flex flex-row last:*:flex-1 gap-4 items-start"
                    })
              ],
              className: "mx-auto flex flex-col max-w-[60rem] gap-4"
            });
}

var $$default = Pages_HeaderLayout$default;

export {
  $$default as default,
}
/* next/link Not a pure module */
