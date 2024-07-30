/** Types generated for queries found in "src/Pages_Main.res" */
open PgTyped


/** 'Query1' parameters type */
@gentype
type query1Params = unit

/** 'Query1' return type */
@gentype
type query1Result = {
  author_id: string,
  author_name: string,
  comments_count: bigint,
  first_published_at: Date.t,
  id: int,
  likes_count: bigint,
  title: string,
  views_count: bigint,
}

/** 'Query1' query type */
@gentype
type query1Query = {
  params: query1Params,
  result: query1Result,
}

%%private(let query1IR: IR.t = %raw(`{"usedParamSet":{},"params":[],"statement":"SELECT a.id, title as \"title!\", author_id, name as author_name,\n      first_published_at as \"first_published_at!\", comments_count as \"comments_count!\", views_count as \"views_count!\", likes_count as \"likes_count!\"\n    FROM last_editions e\n    JOIN articles a ON e.article_id = a.id\n    JOIN users u ON a.author_id = u.id\n    JOIN article_stats s ON a.id = s.id\n    ORDER BY first_published_at DESC"}`))

/**
 Runnable query:
 ```sql
SELECT a.id, title as "title!", author_id, name as author_name,
      first_published_at as "first_published_at!", comments_count as "comments_count!", views_count as "views_count!", likes_count as "likes_count!"
    FROM last_editions e
    JOIN articles a ON e.article_id = a.id
    JOIN users u ON a.author_id = u.id
    JOIN article_stats s ON a.id = s.id
    ORDER BY first_published_at DESC
 ```

 */
@gentype
module Query1: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, query1Params) => promise<array<query1Result>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, query1Params) => promise<option<query1Result>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    query1Params,
    ~errorMessage: string=?
  ) => promise<query1Result>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, query1Params) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external query1: IR.t => PreparedStatement.t<query1Params, query1Result> = "PreparedQuery";
  let query = query1(query1IR)
  let query = (params, ~client) => query->PreparedStatement.run(params, ~client)

  @gentype
  let many = (client, params) => query(params, ~client)

  @gentype
  let one = async (client, params) => switch await query(params, ~client) {
  | [item] => Some(item)
  | _ => None
  }

  @gentype
  let expectOne = async (client, params, ~errorMessage=?) => switch await query(params, ~client) {
  | [item] => item
  | _ => panic(errorMessage->Option.getOr("More or less than one item was returned"))
  }

  @gentype
  let execute = async (client, params) => {
    let _ = await query(params, ~client)
  }
}

@gentype
@deprecated("Use 'Query1.many' directly instead")
let query1 = (params, ~client) => Query1.many(client, params)


