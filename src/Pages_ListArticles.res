@jsx.component
let default = async () => {
  switch await %sql.many(`
    SELECT a.id, title as "title!", author_id, name as "authorName",
      first_published_at as "publishedAt!", comments_count as "commentsCount!", views_count as "views_count!", likes_count as "likes_count!"
    FROM last_editions e
    JOIN articles a ON e.article_id = a.id
    JOIN users u ON a.author_id = u.id
    JOIN article_stats s ON a.id = s.id
    ORDER BY first_published_at DESC;
  `)->Db.query() {
  | Ok(articles) =>
    open Components_ArticleList
    <Container>
      {articles
      ->Array.map(article => <Item item={(article :> Item.t)} key={article.id->Int.toString} />)
      ->React.array}
    </Container>
  | Error(_) => <main> {"error"->React.string} </main>
  }
}
