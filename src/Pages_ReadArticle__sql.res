/** Types generated for queries found in "src/Pages_ReadArticle.res" */
open PgTyped


/** 'GetFiles' parameters type */
@gentype
type getFilesParams = {
  id: int,
}

/** 'GetFiles' return type */
@gentype
type getFilesResult = {
  id: int,
  name: string,
}

/** 'GetFiles' query type */
@gentype
type getFilesQuery = {
  params: getFilesParams,
  result: getFilesResult,
}

%%private(let getFilesIR: IR.t = %raw(`{"usedParamSet":{"id":true},"params":[{"name":"id","required":true,"transform":{"type":"scalar"},"locs":[{"a":111,"b":114}]}],"statement":"SELECT id, name\n        FROM files\n        WHERE edition_id = (SELECT id FROM last_editions WHERE article_id = :id!)"}`))

/**
 Runnable query:
 ```sql
SELECT id, name
        FROM files
        WHERE edition_id = (SELECT id FROM last_editions WHERE article_id = $1)
 ```

 */
@gentype
module GetFiles: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getFilesParams) => promise<array<getFilesResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getFilesParams) => promise<option<getFilesResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getFilesParams,
    ~errorMessage: string=?
  ) => promise<getFilesResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getFilesParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getFiles: IR.t => PreparedStatement.t<getFilesParams, getFilesResult> = "PreparedQuery";
  let query = getFiles(getFilesIR)
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
@deprecated("Use 'GetFiles.many' directly instead")
let getFiles = (params, ~client) => GetFiles.many(client, params)


/** 'GetLikes' parameters type */
@gentype
type getLikesParams = {
  id: int,
}

/** 'GetLikes' return type */
@gentype
type getLikesResult = {
  id: string,
  name: string,
}

/** 'GetLikes' query type */
@gentype
type getLikesQuery = {
  params: getLikesParams,
  result: getLikesResult,
}

%%private(let getLikesIR: IR.t = %raw(`{"usedParamSet":{"id":true},"params":[{"name":"id","required":true,"transform":{"type":"scalar"},"locs":[{"a":120,"b":123}]}],"statement":"SELECT user_id AS id, name\n        FROM likes\n        JOIN users ON likes.user_id = users.id\n        WHERE article_id = :id!\n        ORDER BY created_at ASC"}`))

/**
 Runnable query:
 ```sql
SELECT user_id AS id, name
        FROM likes
        JOIN users ON likes.user_id = users.id
        WHERE article_id = $1
        ORDER BY created_at ASC
 ```

 */
@gentype
module GetLikes: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getLikesParams) => promise<array<getLikesResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getLikesParams) => promise<option<getLikesResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getLikesParams,
    ~errorMessage: string=?
  ) => promise<getLikesResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getLikesParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getLikes: IR.t => PreparedStatement.t<getLikesParams, getLikesResult> = "PreparedQuery";
  let query = getLikes(getLikesIR)
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
@deprecated("Use 'GetLikes.many' directly instead")
let getLikes = (params, ~client) => GetLikes.many(client, params)


/** 'GetArticle' parameters type */
@gentype
type getArticleParams = {
  id: int,
}

/** 'GetArticle' return type */
@gentype
type getArticleResult = {
  authorName: string,
  content: string,
  editionId: int,
  editionsCount: option<int>,
  firstPublishedAt: string,
  id: int,
  lastPublishedAt: string,
  title: string,
  viewsCount: int,
}

/** 'GetArticle' query type */
@gentype
type getArticleQuery = {
  params: getArticleParams,
  result: getArticleResult,
}

%%private(let getArticleIR: IR.t = %raw(`{"usedParamSet":{"id":true},"params":[{"name":"id","required":true,"transform":{"type":"scalar"},"locs":[{"a":489,"b":492}]}],"statement":"SELECT a.id, title AS \"title!\", content AS \"content!\", name AS \"authorName!\", views_count AS \"viewsCount!\", e.id AS \"editionId!\",\n        first_published_at AS \"firstPublishedAt!\", last_published_at AS \"lastPublishedAt!\",\n        (SELECT COUNT(*) FROM editions WHERE article_id = a.id) AS \"editionsCount\"\n        FROM last_editions e\n        JOIN articles a ON e.article_id = a.id\n        JOIN users u ON a.author_id = u.id\n        JOIN article_stats s ON a.id = s.id\n        WHERE a.id = :id!"}`))

/**
 Runnable query:
 ```sql
SELECT a.id, title AS "title!", content AS "content!", name AS "authorName!", views_count AS "viewsCount!", e.id AS "editionId!",
        first_published_at AS "firstPublishedAt!", last_published_at AS "lastPublishedAt!",
        (SELECT COUNT(*) FROM editions WHERE article_id = a.id) AS "editionsCount"
        FROM last_editions e
        JOIN articles a ON e.article_id = a.id
        JOIN users u ON a.author_id = u.id
        JOIN article_stats s ON a.id = s.id
        WHERE a.id = $1
 ```

 */
@gentype
module GetArticle: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getArticleParams) => promise<array<getArticleResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getArticleParams) => promise<option<getArticleResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getArticleParams,
    ~errorMessage: string=?
  ) => promise<getArticleResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getArticleParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getArticle: IR.t => PreparedStatement.t<getArticleParams, getArticleResult> = "PreparedQuery";
  let query = getArticle(getArticleIR)
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
@deprecated("Use 'GetArticle.many' directly instead")
let getArticle = (params, ~client) => GetArticle.many(client, params)


