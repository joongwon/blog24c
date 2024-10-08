'use client'
// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Core__Nullable from "@rescript/core/src/Core__Nullable.res.js";
import * as JsxRuntime from "react/jsx-runtime";

function Pages_HeaderLayout_Header(props) {
  var match = React.useState(function () {
        return 0;
      });
  var setTransY = match[1];
  var transY = match[0];
  var headerRef = React.useRef(null);
  var lastScrollY = React.useRef(0.0);
  React.useEffect((function () {
          lastScrollY.current = window.scrollY;
          var ticking = {
            contents: false
          };
          var currentScrollY = {
            contents: window.scrollY
          };
          var scrollHandler = function (param) {
            currentScrollY.contents = Math.min(Math.max(window.scrollY, 0.0), document.documentElement.scrollHeight - window.innerHeight | 0);
            if (!ticking.contents) {
              ticking.contents = true;
              requestAnimationFrame(function (param) {
                    var headerHeight = Core__Nullable.getOr(Core__Nullable.map(headerRef.current, (function (header) {
                                return header.getBoundingClientRect().height;
                              })), 0.0) + 5.0;
                    var scrollDelta = currentScrollY.contents - lastScrollY.current;
                    if (scrollDelta > 20) {
                      setTransY(function (param) {
                            return - headerHeight;
                          });
                      lastScrollY.current = currentScrollY.contents;
                    } else if (scrollDelta < -20) {
                      setTransY(function (param) {
                            return 0;
                          });
                      lastScrollY.current = currentScrollY.contents;
                    }
                    ticking.contents = false;
                  });
              return ;
            }
            
          };
          window.addEventListener("scroll", scrollHandler);
          return (function () {
                    window.removeEventListener("scroll", scrollHandler);
                  });
        }), [setTransY]);
  var style = React.useMemo((function () {
          return {
                  transform: "translateY(" + transY.toString() + "px)"
                };
        }), [transY]);
  return JsxRuntime.jsx("header", {
              children: props.children,
              ref: Caml_option.some(headerRef),
              className: "flex flex-wrap justify-between bg-neutral-200 p-4 transition-transform top-0 sticky",
              style: style
            });
}

var make = Pages_HeaderLayout_Header;

export {
  make ,
}
/* react Not a pure module */
