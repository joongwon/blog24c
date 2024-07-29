// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Make(S) {
  var value = {
    contents: S.initial()
  };
  var listeners = new Set();
  var hooks = [];
  var useSync = function () {
    return React.useSyncExternalStore((function (listener) {
                  listeners.add(listener);
                  return function () {
                    listeners.delete(listener);
                  };
                }), (function () {
                  return value.contents;
                }), (function () {
                  return value.contents;
                }));
  };
  var update = function (newState) {
    hooks.forEach(function (hook) {
          hook(newState);
        });
    value.contents = newState;
    listeners.forEach(function (listener) {
          listener();
        });
  };
  var addHook = function (hook) {
    hooks.push(hook);
  };
  return {
          useSync: useSync,
          update: update,
          addHook: addHook
        };
}

export {
  Make ,
}
/* react Not a pure module */
