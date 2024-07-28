@module("react-markdown") @react.component
external make: (~children: string, ~urlTransform: string => string=?) => React.element = "default"

@module("react-markdown")
external defaultUrlTransform: string => string = "defaultUrlTransform"
