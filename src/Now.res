@@directive(`'use client';`)

let state = ref(Date.now())
let listeners = Set.make()

let use = () =>
  React_.useSyncExternalStore(
    ~subscribe=listener => {
      listeners->Set.add(listener)
      () => listeners->Set.delete(listener)->ignore
    },
    ~getSnapshot=() => state.contents,
    ~getServerSnapshot=Some(() => Date.now()),
  )

let timeout = ref(None)

let rec update = newState => {
  state := newState

  timeout.contents->Option.map(clearTimeout)->ignore
  // refresh after 1 minute
  timeout := setTimeout(() => {
      update(Date.now())
    }, 60 * 1000)->Some

  listeners->Set.forEach(listener => listener())
}

update(Date.now())
