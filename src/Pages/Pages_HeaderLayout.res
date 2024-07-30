@react.component
let default = (~children) => {
  module AuthMenu = Pages_HeaderLayout_AuthMenu
  module NavMenu = Pages_HeaderLayout_NavMenu
  module Header = Pages_HeaderLayout_Header
  let title = "왼손잡이해방연대 아지트"
  <body className="mx-auto flex flex-col max-w-[60rem] gap-4">
    <Header>
      <Next.Link className={"text-2xl font-bold"->Some} href="/"> {title->React.string} </Next.Link>
      <AuthMenu />
    </Header>
    <div className="flex flex-row last:*:flex-1 last:*:m-4 last:*:min-w-0 gap-4 items-start">
      <NavMenu />
      children
    </div>
  </body>
}
