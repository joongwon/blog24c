// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Db from "../Db.res.js";
import * as Env from "../Env.res.js";
import * as Icons from "../Icons.res.js";
import * as React from "react";
import * as Core__Int from "@rescript/core/src/Core__Int.res.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Components_Stat from "../Components/Components_Stat.res.js";
import * as Components_Time from "../Components/Components_Time.res.js";
import * as $$Navigation from "next/navigation";
import * as JsxRuntime from "react/jsx-runtime";
import * as Components_ArticleList from "../Components/Components_ArticleList.res.js";
import * as Pages_ReadArticle__sql from "./Pages_ReadArticle__sql.res.js";
import * as Components_ArticleViewer from "../Components/Components_ArticleViewer.res.js";
import * as Pages_ReadArticle_Buttons from "./Pages_ReadArticle_Buttons.res.js";

var query = React.cache(function (aid) {
      return Db.tx(async function (client) {
                  var article = await Pages_ReadArticle__sql.GetArticle.one(client, {
                        aid: aid
                      });
                  var likes = await Pages_ReadArticle__sql.GetLikes.many(client, {
                        aid: aid
                      });
                  var files = await Pages_ReadArticle__sql.GetFiles.many(client, {
                        aid: aid
                      });
                  var comments = await Pages_ReadArticle__sql.GetComments.many(client, {
                        aid: aid
                      });
                  var next = await Pages_ReadArticle__sql.GetNext.one(client, {
                        aid: aid
                      });
                  var prev = await Pages_ReadArticle__sql.GetPrev.one(client, {
                        aid: aid
                      });
                  return [
                          article,
                          [
                            likes,
                            files,
                            comments,
                            prev,
                            next
                          ]
                        ];
                });
    });

async function $$default(param) {
  var aid = param.params.aid;
  var aid$1 = Core__Int.fromString(aid, undefined);
  if (aid$1 === undefined) {
    return $$Navigation.notFound();
  }
  var result = await query(aid$1);
  var article = result[0];
  if (article === undefined) {
    return $$Navigation.notFound();
  }
  var match = result[1];
  var next = match[4];
  var prev = match[3];
  var comments = match[2];
  var likes = match[0];
  return JsxRuntime.jsxs("main", {
              children: [
                JsxRuntime.jsxs("header", {
                      children: [
                        JsxRuntime.jsx("h1", {
                              children: article.title,
                              className: "font-bold text-3xl"
                            }),
                        JsxRuntime.jsxs("p", {
                              children: [
                                article.authorName + ", ",
                                JsxRuntime.jsx(Components_Time.make, {
                                      children: article.firstPublishedAt
                                    }),
                                article.firstPublishedAt !== article.lastPublishedAt ? JsxRuntime.jsxs(JsxRuntime.Fragment, {
                                        children: [
                                          " (개정: ",
                                          JsxRuntime.jsx(Components_Time.make, {
                                                children: article.lastPublishedAt
                                              }),
                                          ")"
                                        ]
                                      }) : null
                              ],
                              className: "text-xs"
                            }),
                        JsxRuntime.jsxs("p", {
                              children: [
                                JsxRuntime.jsx(Components_Stat.make, {
                                      icon: JsxRuntime.jsx(Icons.Visibility.make, {}),
                                      count: article.viewsCount
                                    }),
                                JsxRuntime.jsx(Components_Stat.make, {
                                      icon: JsxRuntime.jsx(Icons.Favorite.make, {}),
                                      count: likes.length
                                    })
                              ],
                              className: "text-xs"
                            })
                      ]
                    }),
                JsxRuntime.jsx(Components_ArticleViewer.make, {
                      article: article,
                      files: match[1],
                      fileSuffix: Env.staticUrl + "/" + article.editionId.toString()
                    }),
                JsxRuntime.jsx(Pages_ReadArticle_Buttons.make, {
                      aid: aid$1,
                      likes: likes,
                      commentsCount: comments.length
                    }),
                JsxRuntime.jsx("section", {
                      children: comments.length > 0 ? JsxRuntime.jsx("ul", {
                              children: comments.map(function (comment) {
                                    return JsxRuntime.jsxs("li", {
                                                children: [
                                                  JsxRuntime.jsx("p", {
                                                        children: comment.content
                                                      }),
                                                  JsxRuntime.jsxs("footer", {
                                                        children: [
                                                          comment.name + ", ",
                                                          JsxRuntime.jsx(Components_Time.make, {
                                                                children: comment.createdAt
                                                              })
                                                        ],
                                                        className: "text-sm text-neutral-500"
                                                      })
                                                ],
                                                className: "border-b last:border-b-0 py-2"
                                              }, comment.id.toString());
                                  })
                            }) : JsxRuntime.jsx("p", {
                              children: "댓글이 없습니다.",
                              className: "text-center p-6 text-neutral-500"
                            }),
                      className: "border-y my-8"
                    }),
                JsxRuntime.jsxs(Components_ArticleList.make, {
                      children: [
                        next !== undefined ? JsxRuntime.jsx(Components_ArticleList.Item.make, {
                                item: next,
                                icon: Caml_option.some(JsxRuntime.jsx(Icons.ArrowUp.make, {}))
                              }) : JsxRuntime.jsx(Components_ArticleList.Placeholder.make, {
                                children: "(마지막 글입니다)",
                                icon: Caml_option.some(JsxRuntime.jsx(Icons.ArrowUp.make, {}))
                              }),
                        prev !== undefined ? JsxRuntime.jsx(Components_ArticleList.Item.make, {
                                item: prev,
                                icon: Caml_option.some(JsxRuntime.jsx(Icons.ArrowDown.make, {}))
                              }) : JsxRuntime.jsx(Components_ArticleList.Placeholder.make, {
                                children: "(첫번째 글입니다)",
                                icon: Caml_option.some(JsxRuntime.jsx(Icons.ArrowDown.make, {}))
                              })
                      ]
                    })
              ]
            });
}

var Pages_ReadArticle$default = $$default;

async function generateMetadata(props) {
  var aid = Core__Int.fromString(props.params.aid, undefined);
  if (aid === undefined) {
    return $$Navigation.notFound();
  }
  var match = await query(aid);
  var article = match[0];
  if (article === undefined) {
    return $$Navigation.notFound();
  }
  var title = article.title;
  var description = article.content.substring(0, 100);
  return {
          title: title,
          description: description
        };
}

var $$default$1 = Pages_ReadArticle$default;

export {
  query ,
  $$default$1 as default,
  generateMetadata ,
}
/* query Not a pure module */
