/** Types generated for queries found in "src/Pages/Pages_ReadArticle.res" */
open PgTyped


/** 'GetPrev' parameters type */
@gentype
type getPrevParams = {
  aid: int,
}

/** 'GetPrev' return type */
@gentype
type getPrevResult = {
  authorName: string,
  commentsCount: int,
  id: int,
  likesCount: int,
  publishedAt: string,
  title: string,
  viewsCount: int,
}

/** 'GetPrev' query type */
@gentype
type getPrevQuery = {
  params: getPrevParams,
  result: getPrevResult,
}

%%private(let getPrevIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":594,"b":598}]}],"statement":"SELECT\n          a.id,\n          title               AS \"title!\",\n          name                AS \"authorName!\",\n          first_published_at  AS \"publishedAt!\",\n          comments_count      AS \"commentsCount!\",\n          views_count         AS \"viewsCount!\",\n          likes_count         AS \"likesCount!\"\n        FROM last_editions e\n          JOIN articles a       ON e.article_id = a.id\n          JOIN users u          ON a.author_id = u.id\n          JOIN article_stats s  ON a.id = s.id\n        WHERE first_published_at < (SELECT first_published_at FROM last_editions WHERE article_id = :aid!)\n        ORDER BY first_published_at DESC LIMIT 1"}`))

/**
 Runnable query:
 ```sql
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
        WHERE first_published_at < (SELECT first_published_at FROM last_editions WHERE article_id = $1)
        ORDER BY first_published_at DESC LIMIT 1
 ```

 */
@gentype
module GetPrev: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getPrevParams) => promise<array<getPrevResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getPrevParams) => promise<option<getPrevResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getPrevParams,
    ~errorMessage: string=?
  ) => promise<getPrevResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getPrevParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getPrev: IR.t => PreparedStatement.t<getPrevParams, getPrevResult> = "PreparedQuery";
  let query = getPrev(getPrevIR)
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
@deprecated("Use 'GetPrev.many' directly instead")
let getPrev = (params, ~client) => GetPrev.many(client, params)


/** 'GetNext' parameters type */
@gentype
type getNextParams = {
  aid: int,
}

/** 'GetNext' return type */
@gentype
type getNextResult = {
  authorName: string,
  commentsCount: int,
  id: int,
  likesCount: int,
  publishedAt: string,
  title: string,
  viewsCount: int,
}

/** 'GetNext' query type */
@gentype
type getNextQuery = {
  params: getNextParams,
  result: getNextResult,
}

%%private(let getNextIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":594,"b":598}]}],"statement":"SELECT\n          a.id,\n          title               AS \"title!\",\n          name                AS \"authorName!\",\n          first_published_at  AS \"publishedAt!\",\n          comments_count      AS \"commentsCount!\",\n          views_count         AS \"viewsCount!\",\n          likes_count         AS \"likesCount!\"\n        FROM last_editions e\n          JOIN articles a       ON e.article_id = a.id\n          JOIN users u          ON a.author_id = u.id\n          JOIN article_stats s  ON a.id = s.id\n        WHERE first_published_at > (SELECT first_published_at FROM last_editions WHERE article_id = :aid!)\n        ORDER BY first_published_at ASC LIMIT 1"}`))

/**
 Runnable query:
 ```sql
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
        WHERE first_published_at > (SELECT first_published_at FROM last_editions WHERE article_id = $1)
        ORDER BY first_published_at ASC LIMIT 1
 ```

 */
@gentype
module GetNext: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getNextParams) => promise<array<getNextResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getNextParams) => promise<option<getNextResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getNextParams,
    ~errorMessage: string=?
  ) => promise<getNextResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getNextParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getNext: IR.t => PreparedStatement.t<getNextParams, getNextResult> = "PreparedQuery";
  let query = getNext(getNextIR)
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
@deprecated("Use 'GetNext.many' directly instead")
let getNext = (params, ~client) => GetNext.many(client, params)


/** 'GetComments' parameters type */
@gentype
type getCommentsParams = {
  aid: int,
}

/** 'GetComments' return type */
@gentype
type getCommentsResult = {
  author_id: string,
  content: string,
  createdAt: string,
  id: int,
  name: string,
}

/** 'GetComments' query type */
@gentype
type getCommentsQuery = {
  params: getCommentsParams,
  result: getCommentsResult,
}

%%private(let getCommentsIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":225,"b":229}]}],"statement":"SELECT\n          comments.id,\n          content,\n          created_at AS \"createdAt\",\n          author_id,\n          name\n        FROM comments\n          JOIN users ON comments.author_id = users.id\n        WHERE article_id = :aid!\n        ORDER BY created_at DESC"}`))

/**
 Runnable query:
 ```sql
SELECT
          comments.id,
          content,
          created_at AS "createdAt",
          author_id,
          name
        FROM comments
          JOIN users ON comments.author_id = users.id
        WHERE article_id = $1
        ORDER BY created_at DESC
 ```

 */
@gentype
module GetComments: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getCommentsParams) => promise<array<getCommentsResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getCommentsParams) => promise<option<getCommentsResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getCommentsParams,
    ~errorMessage: string=?
  ) => promise<getCommentsResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getCommentsParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getComments: IR.t => PreparedStatement.t<getCommentsParams, getCommentsResult> = "PreparedQuery";
  let query = getComments(getCommentsIR)
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
@deprecated("Use 'GetComments.many' directly instead")
let getComments = (params, ~client) => GetComments.many(client, params)


/** 'GetFiles' parameters type */
@gentype
type getFilesParams = {
  aid: int,
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

%%private(let getFilesIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":131,"b":135}]}],"statement":"SELECT\n          id,\n          name\n        FROM files\n        WHERE edition_id = (SELECT id FROM last_editions WHERE article_id = :aid!)"}`))

/**
 Runnable query:
 ```sql
SELECT
          id,
          name
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
  aid: int,
}

/** 'GetLikes' return type */
@gentype
type getLikesResult = {
  name: string,
}

/** 'GetLikes' query type */
@gentype
type getLikesQuery = {
  params: getLikesParams,
  result: getLikesResult,
}

%%private(let getLikesIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":117,"b":121}]}],"statement":"SELECT\n          name\n        FROM likes\n          JOIN users ON likes.user_id = users.id\n        WHERE article_id = :aid!\n        ORDER BY created_at ASC"}`))

/**
 Runnable query:
 ```sql
SELECT
          name
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
  aid: int,
}

/** 'GetArticle' return type */
@gentype
type getArticleResult = {
  authorName: string,
  content: string,
  editionId: int,
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

%%private(let getArticleIR: IR.t = %raw(`{"usedParamSet":{"aid":true},"params":[{"name":"aid","required":true,"transform":{"type":"scalar"},"locs":[{"a":582,"b":586}]}],"statement":"SELECT\n            a.id,\n            title               AS \"title!\",\n            content             AS \"content!\",\n            name                AS \"authorName!\",\n            views_count         AS \"viewsCount!\",\n            e.id                AS \"editionId!\",\n            first_published_at  AS \"firstPublishedAt!\",\n            last_published_at   AS \"lastPublishedAt!\"\n        FROM last_editions e\n          JOIN articles a       ON e.article_id = a.id\n          JOIN users u          ON a.author_id = u.id\n          JOIN article_stats s  ON a.id = s.id\n        WHERE a.id = :aid!"}`))

/**
 Runnable query:
 ```sql
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


