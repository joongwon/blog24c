module type S = {
  type t
  let initial: unit => t
}

module Make = (S: S) => {
  type t = S.t

  %%private(
    let value = ref(S.initial())
    let listeners = Set.make()
    let hooks = []
  )
  let useSync = () => {
    React.useSyncExternalStoreWithServerSnapshot(
      ~subscribe=listener => {
        listeners->Set.add(listener)
        () => listeners->Set.delete(listener)->ignore
      },
      ~getSnapshot=() => value.contents,
      ~getServerSnapshot=() => value.contents,
    )
  }
  let update = (newState: t) => {
    hooks->Array.forEach(hook => hook(newState))
    value := newState
    listeners->Set.forEach(listener => listener())
  }
  let addHook = hook => {
    hooks->Array.push(hook)
  }
}
