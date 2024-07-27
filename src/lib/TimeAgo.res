type formatter = (
  int,
  [#second | #minute | #hour | #day | #week | #month | #year],
  [#ago | #"from now"],
  int,
  unit => string,
) => string

@module("react-timeago") @react.component
external make: (
  ~date: Date.t,
  ~maxPeriod: option<int>=?,
  ~formatter: formatter,
  ~title: option<string>=?,
  ~now: option<float>=?,
  ~suppressHydrationWarning: option<bool>=?,
) => React.element = "default"
