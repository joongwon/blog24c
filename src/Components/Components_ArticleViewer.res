@@directive(`'use client'`)

type file = {
  id: int,
  name: string,
}

type article = {content: string}

type renderer = [
  | #Markdown
  | #Text
]

module Markdown = {
  @react.component
  let make = (~children, ~files) => {
    let urlTransform = (url: string) => {
      if url->String.startsWith("./") {
        let fileName = url->String.sliceToEnd(~start=2)->Js.Global.decodeURI
        files
        ->Array.find(file => file.name === fileName)
        ->Option.mapOr("", file => `${file.id->Int.toString}/${file.name->String.normalize}`)
      } else {
        ReactMarkdown.defaultUrlTransform(url)
      }
    }
    <ReactMarkdown urlTransform> {children} </ReactMarkdown>
  }
}

module Text = {
  @react.component
  let make = (~children) => {
    <p>
      {children
      ->String.split("\n")
      ->Array.flatMapWithIndex((line, j) => [line->React.string, <br key={j->Int.toString} />])
      ->React.array}
    </p>
  }
}

let estimateType = (content: string) => {
  let pat = %re("/^([>*-] |#|```|!\[)|\]\(/m")
  pat->RegExp.test(content) ? #Markdown : #Text
}

module ContentTypeOption = {
  @react.component
  let make = (~contentType, ~setContentType, ~optionValue: renderer) => {
    <button
      className={if contentType === optionValue {
        "bg-neutral-200 "
      } else {
        "bg-white "
      } ++ "px-2 py-2 text-xs first:rounded-l-xl last:rounded-r-xl border border-neutral-300 hover:bg-neutral-300"}
      onClick={_ => setContentType(_ => optionValue)}>
      {(optionValue :> string)->React.string}
    </button>
  }
}

@react.component
let make = (~article, ~files, ~fileSuffix) => {
  let (contentType, setContentType) = React.useState(() => estimateType(article.content))
  <article>
    /* content type option */
    <div className="flex justify-end">
      <ContentTypeOption contentType setContentType optionValue=#Markdown />
      <ContentTypeOption contentType setContentType optionValue=#Text />
    </div>
    /* article content */
    {switch contentType {
    | #Markdown => <Markdown files> {article.content} </Markdown>
    | #Text => <Text> {article.content} </Text>
    }}
    /* attached files */
    {if files->Array.length > 0 {
      <details>
        <summary> {"첨부파일"->React.string} </summary>
        <ul>
          {files
          ->Array.map(file => {
            <li key={file.id->Int.toString}>
              <a href={`${fileSuffix}/${file.id->Int.toString}/${file.name}`}>
                {file.name->React.string}
              </a>
            </li>
          })
          ->React.array}
        </ul>
      </details>
    } else {
      React.null
    }}
  </article>
}

/*
export function Options() {
  const viewerOption = useContext(ViewerOptionContext);
  if (!viewerOption) {
    console.error("ViewerOptionContext not found");
    return null;
  }
  return (
    <section className={cx("options")}>
      <button
        className={cx({
          selected: viewerOption?.type === "markdown",
        })}
        onClick={() => viewerOption?.setType("markdown")}
      >
        Markdown
      </button>
      <button
        className={cx({ selected: viewerOption?.type === "text" })}
        onClick={() => viewerOption?.setType("text")}
      >
        Text
      </button>
    </section>
  );
}


*/
