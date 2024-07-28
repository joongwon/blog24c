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
  ~maxPeriod: int=?,
  ~formatter: formatter,
  ~title: string=?,
  ~now: float=?,
  ~suppressHydrationWarning: bool=?,
  ~className: string=?,
) => React.element = "default"
