@jsx.component
let default = async () => {
  switch await %sql.many(`
    SELECT a.id, title as "title!", author_id, name as author_name,
      first_published_at as "first_published_at!", comments_count as "comments_count!", views_count as "views_count!", likes_count as "likes_count!"
    FROM last_editions e
    JOIN articles a ON e.article_id = a.id
    JOIN users u ON a.author_id = u.id
    JOIN article_stats s ON a.id = s.id
    ORDER BY first_published_at DESC;
  `)->Db.query() {
  | Ok(articles) =>
    <main>
      {articles
      ->Array.map(article =>
        <div key={article.id->Int.toString}>
          <h2> {article.title->React.string} </h2>
          <p> {article.author_name->React.string} </p>
          <p> {article.first_published_at->Date.toString->React.string} </p>
          <p> {article.comments_count->BigInt.toString->React.string} </p>
          <p> {article.views_count->BigInt.toString->React.string} </p>
          <p> {article.likes_count->BigInt.toString->React.string} </p>
        </div>
      )
      ->React.array}
    </main>
  | Error(_) => <main> {"error"->React.string} </main>
  }
}
