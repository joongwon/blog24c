@module("react")
external useSyncExternalStore: (
  ~subscribe: @uncurry (unit => unit) => unit => unit,
  ~getSnapshot: @uncurry unit => 'state,
  ~getServerSnapshot: option<@uncurry unit => 'state>=?,
) => 'state = "useSyncExternalStore"
