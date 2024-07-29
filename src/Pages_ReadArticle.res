let query = React_.cache(aid =>
  Db.tx(async client => {
    let article = await client->%sql.one(`
        /* @name getArticle */
        SELECT
            a.id,
            title               AS "title!",
            content             AS "content!",
            name                AS "authorName!",
            views_count         AS "viewsCount!",
            e.id                AS "editionId!",
            first_published_at  AS "firstPublishedAt!",
            last_published_at   AS "lastPublishedAt!"
        FROM last_editions e
          JOIN articles a       ON e.article_id = a.id
          JOIN users u          ON a.author_id = u.id
          JOIN article_stats s  ON a.id = s.id
        WHERE a.id = :aid!`)({aid: aid})
    let likes = await client->%sql.many(`
        /* @name getLikes */
        SELECT
          name
        FROM likes
          JOIN users ON likes.user_id = users.id
        WHERE article_id = :aid!
        ORDER BY created_at ASC
      `)({aid: aid})
    let files = await client->%sql.many(`
        /* @name getFiles */
        SELECT
          id,
          name
        FROM files
        WHERE edition_id = (SELECT id FROM last_editions WHERE article_id = :aid!)
      `)({aid: aid})
    let comments = await client->%sql.many(`
        /* @name getComments */
        SELECT
          comments.id,
          content,
          created_at AS "createdAt",
          author_id,
          name
        FROM comments
          JOIN users ON comments.author_id = users.id
        WHERE article_id = :aid!
        ORDER BY created_at DESC
      `)({aid: aid})
    let next = await client->%sql.one(`
        /* @name getNext */
        SELECT
          a.id,
          title               AS "title!",
          name                AS "authorName!",
          first_published_at  AS "publishedAt!",
          comments_count      AS "commentsCount!",
          views_count         AS "viewsCount!",
          likes_count         AS "likesCount!"
        FROM last_editions e
          JOIN articles a       ON e.article_id = a.id
          JOIN users u          ON a.author_id = u.id
          JOIN article_stats s  ON a.id = s.id
        WHERE first_published_at > (SELECT first_published_at FROM last_editions WHERE article_id = :aid!)
        ORDER BY first_published_at ASC LIMIT 1
      `)({aid: aid})
    let prev = await client->%sql.one(`
        /* @name getPrev */
        SELECT
          a.id,
          title               AS "title!",
          name                AS "authorName!",
          first_published_at  AS "publishedAt!",
          comments_count      AS "commentsCount!",
          views_count         AS "viewsCount!",
          likes_count         AS "likesCount!"
        FROM last_editions e
          JOIN articles a       ON e.article_id = a.id
          JOIN users u          ON a.author_id = u.id
          JOIN article_stats s  ON a.id = s.id
        WHERE first_published_at < (SELECT first_published_at FROM last_editions WHERE article_id = :aid!)
        ORDER BY first_published_at DESC LIMIT 1
      `)({aid: aid})
    (article, (likes, files, comments, prev, next))
  })
)

@react.component
let default = async (~params) => {
  let aid: string = params["aid"]
  let aid = aid->Int.fromString
  switch aid {
  | None => Next.Navigation.notFound()
  | Some(aid) =>
    let result = await query(aid)
    switch result {
    | Error(error) => raise(error)
    | Ok(None, _) => Next.Navigation.notFound()
    | Ok(Some(article), (likes, files, comments, prev, next)) =>
      module Time = Components_Time
      module Stat = Components_Stat
      module ArticleViewer = Components_ArticleViewer
      module ArticleList = Components_ArticleList
      module Buttons = Pages_ReadArticle_Buttons
      <main>
        <header>
          /* title */
          <h1 className="font-bold text-3xl"> {article.title->React.string} </h1>
          <p className="text-xs">
            /* author name */
            {`${article.authorName}, `->React.string}
            /* published date */
            <Time> {article.firstPublishedAt} </Time>
            {if article.firstPublishedAt != article.lastPublishedAt {
              <>
                {" (개정: "->React.string}
                <Time> {article.lastPublishedAt} </Time>
                {")"->React.string}
              </>
            } else {
              React.null
            }}
          </p>
          <p className="text-xs">
            /* stats */
            <Stat icon={<Icons.Visibility />} count={article.viewsCount} />
            <Stat icon={<Icons.Favorite />} count={likes->Array.length} />
          </p>
        </header>
        /* content & files */
        <ArticleViewer
          article={(article :> ArticleViewer.article)}
          files={(files :> array<ArticleViewer.file>)}
          fileSuffix={`${Env.staticUrl}/${article.editionId->Int.toString}`}
        />
        /* buttons */
        <Buttons
          aid={aid} likes={(likes :> array<Buttons.like>)} commentsCount={comments->Array.length}
        />
        /* comments */
        <section className="border-y mb-8">
          {if comments->Array.length > 0 {
            <ul>
              {comments
              ->Array.map(comment =>
                <li key={comment.id->Int.toString} className="border-b last:border-b-0 py-2">
                  <p> {comment.content->React.string} </p>
                  <footer className="text-sm text-neutral-500">
                    {`${comment.name}, `->React.string}
                    <Time> {comment.createdAt} </Time>
                  </footer>
                </li>
              )
              ->React.array}
            </ul>
          } else {
            <p className="text-center p-6 text-neutral-500">
              {"댓글이 없습니다."->React.string}
            </p>
          }}
        </section>
        /* prev & next */
        <ArticleList>
          {switch next {
          | Some(item) =>
            <ArticleList.Item icon={<Icons.ArrowUp />} item={(item :> ArticleList.Item.t)} />
          | None =>
            <ArticleList.Placeholder icon={<Icons.ArrowUp />}>
              {"(첫번째 글입니다)"}
            </ArticleList.Placeholder>
          }}
          {switch prev {
          | Some(item) =>
            <ArticleList.Item icon={<Icons.ArrowDown />} item={(item :> ArticleList.Item.t)} />
          | None =>
            <ArticleList.Placeholder icon={<Icons.ArrowDown />}>
              {"(마지막 글입니다)"}
            </ArticleList.Placeholder>
          }}
        </ArticleList>
      </main>
    }
  }
}

let generateMetadata = async props => {
  let aid = props.params["aid"]->Int.fromString
  switch aid {
  | None => Next.Navigation.notFound()
  | Some(aid) =>
    switch await query(aid) {
    | Error(error) => raise(error)
    | Ok(None, _) => Next.Navigation.notFound()
    | Ok(Some(article), _) =>
      let title = article.title
      let description = article.content->String.substring(~start=0, ~end=100)
      {
        "title": title,
        "description": description,
      }
    }
  }
}
