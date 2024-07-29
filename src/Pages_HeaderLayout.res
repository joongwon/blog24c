@react.component
let default = (~children) => {
  module AuthMenu = Pages_HeaderLayout_AuthMenu
  let title = "왼손잡이해방연대 아지트"
  <main className="mx-auto flex flex-col max-w-screen-lg p-4">
    <header className="flex justify-between bg-neutral-200 my-4 p-4">
      <Next.Link className={"text-2xl font-bold"->Some} href="/"> {title->React.string} </Next.Link>
      <AuthMenu />
    </header>
    children
  </main>
}
