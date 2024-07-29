/** Types generated for queries found in "src/Actions.res" */
open PgTyped


@gentype
type role = [#"admin" | #"user"]

/** 'GetUserByNaverId' parameters type */
@gentype
type getUserByNaverIdParams = {
  naverId: string,
}

/** 'GetUserByNaverId' return type */
@gentype
type getUserByNaverIdResult = {
  id: string,
  name: string,
  role: role,
}

/** 'GetUserByNaverId' query type */
@gentype
type getUserByNaverIdQuery = {
  params: getUserByNaverIdParams,
  result: getUserByNaverIdResult,
}

%%private(let getUserByNaverIdIR: IR.t = %raw(`{"usedParamSet":{"naverId":true},"params":[{"name":"naverId","required":true,"transform":{"type":"scalar"},"locs":[{"a":50,"b":58}]}],"statement":"SELECT id, name, role FROM users WHERE naver_id = :naverId!"}`))

/**
 Runnable query:
 ```sql
SELECT id, name, role FROM users WHERE naver_id = $1
 ```

 */
@gentype
module GetUserByNaverId: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getUserByNaverIdParams) => promise<array<getUserByNaverIdResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getUserByNaverIdParams) => promise<option<getUserByNaverIdResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getUserByNaverIdParams,
    ~errorMessage: string=?
  ) => promise<getUserByNaverIdResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getUserByNaverIdParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getUserByNaverId: IR.t => PreparedStatement.t<getUserByNaverIdParams, getUserByNaverIdResult> = "PreparedQuery";
  let query = getUserByNaverId(getUserByNaverIdIR)
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
@deprecated("Use 'GetUserByNaverId.many' directly instead")
let getUserByNaverId = (params, ~client) => GetUserByNaverId.many(client, params)


/** 'GetUserById' parameters type */
@gentype
type getUserByIdParams = {
  id: string,
}

/** 'GetUserById' return type */
@gentype
type getUserByIdResult = {
  id: string,
  name: string,
  role: role,
}

/** 'GetUserById' query type */
@gentype
type getUserByIdQuery = {
  params: getUserByIdParams,
  result: getUserByIdResult,
}

%%private(let getUserByIdIR: IR.t = %raw(`{"usedParamSet":{"id":true},"params":[{"name":"id","required":true,"transform":{"type":"scalar"},"locs":[{"a":44,"b":47}]}],"statement":"SELECT id, name, role FROM users WHERE id = :id!"}`))

/**
 Runnable query:
 ```sql
SELECT id, name, role FROM users WHERE id = $1
 ```

 */
@gentype
module GetUserById: {
  /** Returns an array of all matched results. */
  @gentype
  let many: (PgTyped.Pg.Client.t, getUserByIdParams) => promise<array<getUserByIdResult>>
  /** Returns exactly 1 result. Returns `None` if more or less than exactly 1 result is returned. */
  @gentype
  let one: (PgTyped.Pg.Client.t, getUserByIdParams) => promise<option<getUserByIdResult>>
  
  /** Returns exactly 1 result. Raises `Exn.t` (with an optionally provided `errorMessage`) if more or less than exactly 1 result is returned. */
  @gentype
  let expectOne: (
    PgTyped.Pg.Client.t,
    getUserByIdParams,
    ~errorMessage: string=?
  ) => promise<getUserByIdResult>

  /** Executes the query, but ignores whatever is returned by it. */
  @gentype
  let execute: (PgTyped.Pg.Client.t, getUserByIdParams) => promise<unit>
} = {
  @module("pgtyped-rescript-runtime") @new external getUserById: IR.t => PreparedStatement.t<getUserByIdParams, getUserByIdResult> = "PreparedQuery";
  let query = getUserById(getUserByIdIR)
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
@deprecated("Use 'GetUserById.many' directly instead")
let getUserById = (params, ~client) => GetUserById.many(client, params)


