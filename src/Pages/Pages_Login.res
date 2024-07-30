@react.component
let default = (~searchParams) => {
  module Impl = Pages_Login_Impl
  <Impl searchParams clientId={Env.naverClientId} />
}
