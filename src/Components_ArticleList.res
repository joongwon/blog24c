@react.component
let make = (~children) => {
  <ul className="border-t"> children </ul>
}

module ItemBase = {
  @react.component
  let make = (~children, ~icon=React.null) => {
    <li className="border-b p-1 flex items-center flex-wrap">
      icon
      <hr className="border-0 w-1" />
      children
    </li>
  }
}

module Placeholder = {
  @react.component
  let make = (~children, ~icon=React.null) => {
    <ItemBase icon>
      <p className="text-center text-neutral-500"> {children->React.string} </p>
    </ItemBase>
  }
}

module Item = {
  type t = {
    id: int,
    title: string,
    authorName: string,
    publishedAt: string,
    commentsCount: int,
    viewsCount: int,
    likesCount: int,
  }

  @react.component
  let make = (~item, ~icon=React.null) => {
    module Stat = Components_Stat
    module Time = Components_Time
    <ItemBase icon>
      <p>
        /* title link */
        <Next.Link href={`/articles/${item.id->Int.toString}`} className={Some("mr-1")}>
          {item.title->React.string}
        </Next.Link>
        /* statistics */
        <Stat icon={<Icons.Comment />} count={item.commentsCount} />
        <Stat icon={<Icons.Visibility />} count={item.viewsCount} />
        <Stat icon={<Icons.Favorite />} count={item.likesCount} />
      </p>
      /* author & publishedAt */
      <p className="mr-1 text-neutral-500 text-sm whitespace-nowrap min-w-fit flex-1 text-right">
        {`${item.authorName},`->React.string}
        <Time> {item.publishedAt} </Time>
      </p>
    </ItemBase>
  }
}
