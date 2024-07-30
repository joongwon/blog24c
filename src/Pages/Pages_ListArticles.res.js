// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Db from "../Db.res.js";
import * as JsxRuntime from "react/jsx-runtime";
import * as Components_ArticleList from "../Components/Components_ArticleList.res.js";
import * as Pages_ListArticles__sql from "./Pages_ListArticles__sql.res.js";

async function $$default(param) {
  var articles = await Db.query(Pages_ListArticles__sql.Query1.many, undefined);
  return JsxRuntime.jsx("main", {
              children: JsxRuntime.jsx(Components_ArticleList.make, {
                    children: articles.map(function (article) {
                          return JsxRuntime.jsx(Components_ArticleList.Item.make, {
                                      item: article
                                    }, article.id.toString());
                        })
                  }),
              className: "p-4"
            });
}

var Pages_ListArticles$default = $$default;

var $$default$1 = Pages_ListArticles$default;

export {
  $$default$1 as default,
}
/* Db Not a pure module */
