@react.component
let make = (~children) => {
  <ul className="border-t"> children </ul>
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
  let make = (~item) => {
    module Stat = Components_Stat
    module Time = Components_Time
    <li className="border-b p-1 flex items-center flex-wrap">
      <p>
        /* title link */
        <Next.Link href={`/articles/${item.id->Int.toString}`} className={Some("mr-1")}>
          {item.title->React.string}
        </Next.Link>
        /* statistics */
        <Stat icon="/icons/comment.svg" alt="댓글" count={item.commentsCount} />
        <Stat icon="/icons/visibility.svg" alt="조회수" count={item.viewsCount} />
        <Stat icon="/icons/favorite.svg" alt="좋아요" count={item.likesCount} />
      </p>
      /* author */
      <p className="mr-1 text-gray-500 text-sm whitespace-nowrap min-w-fit flex-1 text-right">
        {`${item.authorName},`->React.string}
        <Time> {item.publishedAt} </Time>
      </p>
      /* publishedAt */
    </li>
  }
}
