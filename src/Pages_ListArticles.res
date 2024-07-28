@jsx.component
let default = async () => {
  switch await %sql.many(`
    SELECT a.id, title as "title!", name as "authorName",
      first_published_at as "publishedAt!", comments_count as "commentsCount!", views_count as "viewsCount!", likes_count as "likesCount!"
    FROM last_editions e
    JOIN articles a ON e.article_id = a.id
    JOIN users u ON a.author_id = u.id
    JOIN article_stats s ON a.id = s.id
    ORDER BY first_published_at DESC;
  `)->Db.query() {
  | Ok(articles) =>
    module ArticleList = Components_ArticleList
    <ArticleList>
      {articles
      ->Array.map(article =>
        <ArticleList.Item item={(article :> ArticleList.Item.t)} key={article.id->Int.toString} />
      )
      ->React.array}
    </ArticleList>
  | Error(_) => <main> {"error"->React.string} </main>
  }
}
