@@directive(`'use client'`)

@react.component
let make = (~children) => {
  /*
  // calculated from media query
  let isMobile = ReactResponsive.useMediaQuery({maxWidth: 768})
  let isServer = Utils.useIsServer()
  let stickyHeader = !isServer && isMobile
 */
  let stickyHeader = true

  // translateY value to render
  let (transY, setTransY) = React.useState(() => 0.)

  // header
  let headerRef = React.useRef(Nullable.null)

  // last scrollY used for calculating transY
  let lastScrollY = React.useRef(0.0)

  React.useEffect(() => {
    lastScrollY.current = window->Webapi.Dom.Window.scrollY

    // scroll handler; uses requestAnimationFrame for performance
    let ticking = ref(false)
    let currentScrollY = ref(window->Webapi.Dom.Window.scrollY)
    let scrollHandler = _ => {
      currentScrollY :=
        Math.min(
          Math.max(window->Webapi.Dom.Window.scrollY, 0.0),
          (document->Webapi.Dom.Document.documentElement->Webapi.Dom.Element.scrollHeight -
            window->Webapi.Dom.Window.innerHeight)->Int.toFloat,
        )
      if !ticking.contents {
        ticking := true
        //window.requestAnimationFrame(() => {
        Webapi.requestAnimationFrame(_ => {
          // height + spare for shadow
          let headerHeight =
            headerRef.current
            ->Nullable.map(
              header => header->Webapi.Dom.Element.getBoundingClientRect->Webapi.Dom.DomRect.height,
            )
            ->Nullable.getOr(0.0) +. 5.0

          // calculate transY according to scroll direction
          let scrollDelta = currentScrollY.contents -. lastScrollY.current
          if scrollDelta > 20. {
            setTransY(_ => -.headerHeight)
            lastScrollY.current = currentScrollY.contents
          } else if scrollDelta < -20. {
            setTransY(_ => 0.)
            lastScrollY.current = currentScrollY.contents
          }
          ticking := false
        })
      }
    }
    if stickyHeader {
      window->Webapi.Dom.Window.addEventListener("scroll", scrollHandler)
      Some(() => window->Webapi.Dom.Window.removeEventListener("scroll", scrollHandler))
    } else {
      None
    }
  }, [stickyHeader])

  // prevent transition setting multiple times
  let style = React.useMemo(
    () =>
      stickyHeader
        ? ReactDOM.Style.make(~transform=`translateY(${transY->Float.toString}px)`, ())
        : ReactDOM.Style.make(),
    (stickyHeader, transY),
  )
  <header
    ref={headerRef->ReactDOM.Ref.domRef}
    style
    className="flex flex-wrap justify-between bg-neutral-200 p-4 transition-transform top-0 sticky">
    children
  </header>
}
