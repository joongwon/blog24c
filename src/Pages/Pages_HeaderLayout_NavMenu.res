@@directive(`'use client';`)

module Button = {
  @react.component
  let make = (~children, ~onClick) => {
    <button className="bg-white rounded-full border my-2 size-12 md:hidden" onClick>
      children
    </button>
  }
}

@react.component
let make = () => {
  let (isOpen, setIsOpen) = React.useState(() => true)
  let handleToggle = e => {
    e->ReactEvent.Mouse.stopPropagation
    setIsOpen(prev => !prev)
  }
  let handleGoToTop = _ => {
    Webapi.Dom.window->Webapi.Dom.Window.scrollToWithOptions({
      "left": 0.0,
      "top": 0.0,
      "behavior": "smooth",
    })
  }
  let menus = [("소개", "/"), ("모든 일지", "/articles")]
  <nav
    className="fixed bottom-0 right-0 m-8 flex flex-col text-xl md:static md:inset-auto md:m-0 md:text-base md:bg-neutral-200 md:p-4">
    /* overlay */
    <div
      className={"fixed opacity-75 bg-white inset-0 -z-10 md:hidden" ++ (isOpen ? "" : " hidden")}
      onClick={_ => setIsOpen(_ => false)}
    />
    <ul
      className={"absolute right-0 bottom-full whitespace-nowrap text-right md:static md:inset-auto md:block md:text-left" ++ (
        isOpen ? "" : " hidden"
      )}>
      {menus
      ->Array.map(((text, href)) => {
        <li key={href} onClick={_ => setIsOpen(_ => false)}>
          <Next.Link href> {text->React.string} </Next.Link>
        </li>
      })
      ->React.array}
    </ul>
    <Button onClick={handleToggle}> {isOpen ? <Icons.Close /> : <Icons.Menu />} </Button>
    <Button onClick={handleGoToTop}>
      <Icons.GoToTop />
    </Button>
  </nav>
}
