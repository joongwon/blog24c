// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Core__Option from "@rescript/core/src/Core__Option.res.js";
import * as RescriptCore from "@rescript/core/src/RescriptCore.res.js";
import * as PgtypedRescriptRuntime from "pgtyped-rescript-runtime";

var query1IR = {"usedParamSet":{},"params":[],"statement":"SELECT a.id, title as \"title!\", author_id, name as \"authorName\",\n      first_published_at as \"publishedAt!\", comments_count as \"commentsCount!\", views_count as \"views_count!\", likes_count as \"likes_count!\"\n    FROM last_editions e\n    JOIN articles a ON e.article_id = a.id\n    JOIN users u ON a.author_id = u.id\n    JOIN article_stats s ON a.id = s.id\n    ORDER BY first_published_at DESC"};

var query = new PgtypedRescriptRuntime.PreparedQuery(query1IR);

function many(client, params) {
  return query.run(params, client);
}

async function one(client, params) {
  var match = await query.run(params, client);
  if (match.length !== 1) {
    return ;
  } else {
    return match[0];
  }
}

async function expectOne(client, params, errorMessage) {
  var match = await query.run(params, client);
  if (match.length !== 1) {
    return RescriptCore.panic(Core__Option.getOr(errorMessage, "More or less than one item was returned"));
  } else {
    return match[0];
  }
}

async function execute(client, params) {
  await query.run(params, client);
}

var Query1 = {
  many: many,
  one: one,
  expectOne: expectOne,
  execute: execute
};

function query1(params, client) {
  return query.run(params, client);
}

export {
  Query1 ,
  query1 ,
}
/* query Not a pure module */
