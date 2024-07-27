module Container = {
  @react.component
  let make = (~children) => {
    <ul className="border-t"> children </ul>
  }
}

module Item = {
  type t = {
    id: int,
    title: string,
    authorName: string,
    publishedAt: string,
  }

  @react.component
  let make = (~item) => {
    module Time = Components_Time
    <li className="border-b p-1 flex">
      /* title link */
      <Next.Link href={`/articles/${item.id->Int.toString}`} className={Some("flex-1")}>
        {item.title->React.string}
      </Next.Link>
      /* author */
      <p className="mr-1"> {`${item.authorName},`->React.string} </p>
      /* publishedAt */
      <Time> {item.publishedAt} </Time>
    </li>
  }
}
