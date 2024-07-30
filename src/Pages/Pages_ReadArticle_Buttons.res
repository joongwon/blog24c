@@directive(`'use client'`)
type like = {name: string}

module Button = {
  @react.component
  let make = (~className="", ~children, ~href="", ~onClick=() => ()) => {
    let className =
      "rounded border border-gray-300 px-2 py-1 text-sm flex gap-1 items-center hover:bg-neutral-200 " ++
      className
    if href === "" {
      <button className onClick={_ => onClick()}> children </button>
    } else {
      <Next.Link className href onClick> children </Next.Link>
    }
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
    <p className="text-sm text-neutral-500 align-bottom h-4 mb-1">
      {likes->Array.length > 0
        ? `${likes
            ->Array.map(like => like.name)
            ->Array.join(", ")}님이 이 일지에 공감합니다`->React.string
        : React.null}
    </p>
    <div className="flex gap-1">
      <Button>
        <Icons.Comment />
        {commentsCount->Int.toString->React.string}
      </Button>
      <Button className="text-red-500" onClick={_ => toggleLike()}>
        <Icons.Favorite className={myLike ? "" : "outlined"} />
        {likes->Array.length->Int.toString->React.string}
      </Button>
      <hr className="border-0 flex-1" />
      <Button href="/articles"> {"목록"->React.string} </Button>
    </div>
  </section>
}
