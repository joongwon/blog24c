@@directive(`'use client'`)
type like = {name: string}

module Button = {
  @react.component
  let make = (~className="", ~children, ~onClick=_ => ()) => {
    <button className={"f " ++ className} onClick> children </button>
  }
}

let useLikes = (~initial) => {
  let (likes, setLikes) = React.useState(() => initial)
  let auth = Auth.useSync()
  let myLike = switch auth {
  | LoggedIn(user) => likes->Array.some(like => like.name === user.profile.name)
  | _ => false
  }
  let toggleLike = () => {
    // TODO
    switch auth {
    | LoggedIn(user) =>
      if myLike {
        setLikes(likes => likes->Array.filter(like => like.name !== user.profile.name))
      } else {
        setLikes(likes => [...likes, {name: user.profile.name}])
      }
    | _ => ()
    }
  }
  (likes, myLike, toggleLike)
}

@react.component
let make = (~aid, ~likes: array<like>, ~commentsCount) => {
  let (likes, myLike, toggleLike) = useLikes(~initial=likes)
  <section>
    {likes->Array.length > 0
      ? <p className="text-sm text-neutral-500">
          {`${likes
            ->Array.map(like => like.name)
            ->Array.join(", ")}님이 이 일지에 공감합니다`->React.string}
        </p>
      : React.null}
    <div className="flex">
      <Button>
        <Icons.Comment />
        {commentsCount->Int.toString->React.string}
      </Button>
      <Button className="text-red-500" onClick={_ => toggleLike()}>
        <Icons.Favorite className={myLike ? "" : "outlined"} />
        {likes->Array.length->Int.toString->React.string}
      </Button>
    </div>
  </section>
}
