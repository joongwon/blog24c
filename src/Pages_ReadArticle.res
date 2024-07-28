let query = aid => async client => {
  let article = await client->%sql.one(`
        /* @name getArticle */
        SELECT a.id, title AS "title!", content AS "content!", name AS "authorName!", views_count AS "viewsCount!", e.id AS "editionId!",
        first_published_at AS "firstPublishedAt!", last_published_at AS "lastPublishedAt!",
        (SELECT COUNT(*) FROM editions WHERE article_id = a.id) AS "editionsCount"
        FROM last_editions e
        JOIN articles a ON e.article_id = a.id
        JOIN users u ON a.author_id = u.id
        JOIN article_stats s ON a.id = s.id
        WHERE a.id = :id!`)({id: aid})
  let likes = await client->%sql.many(`
        /* @name getLikes */
        SELECT user_id AS id, name
        FROM likes
        JOIN users ON likes.user_id = users.id
        WHERE article_id = :id!
        ORDER BY created_at ASC
      `)({id: aid})
  let files = await client->%sql.many(`
        /* @name getFiles */
        SELECT id, name
        FROM files
        WHERE edition_id = (SELECT id FROM last_editions WHERE article_id = :id!)
      `)({id: aid})
  (article, likes, files)
}

@react.component
let default = async (~params) => {
  let aid: string = params["aid"]
  let aid = aid->Int.fromString
  switch aid {
  | None => Next.Navigation.notFound()
  | Some(aid) =>
    let result = await Db.tx(query(aid))
    switch result {
    | Error(error) => raise(error)
    | Ok(None, _, _) => Next.Navigation.notFound()
    | Ok(Some(article), likes, files) =>
      module Time = Components_Time
      module Stat = Components_Stat
      module ArticleViewer = Components_ArticleViewer
      <main>
        <header>
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
            <Stat
              icon="/icons/visibility.svg" alt="조회수" count={article.viewsCount} size="size-4"
            />
            <Stat
              icon="/icons/favorite.svg" alt="좋아요" count={likes->Array.length} size="size-4"
            />
          </p>
        </header>
        <ArticleViewer
          article={(article :> ArticleViewer.article)}
          files={(files :> array<ArticleViewer.file>)}
          fileSuffix={`${Env.staticUrl}/${article.editionId->Int.toString}`}
        />
      </main>
    }
  }
}
