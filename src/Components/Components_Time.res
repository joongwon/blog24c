@@directive(`'use client';`)

let formatter: TimeAgo.formatter = (value, unit, suffix, _, _) => {
  switch (value, unit, suffix) {
  | (1, #day, #ago) => "어제"
  | (2, #day, #ago) => "그저께"
  | (1, #week, #ago) => "지난주"
  | (1, #month, #ago) => "지난달"
  | (1, #year, #ago) => "작년"
  | (_, #second, #ago) => "방금전"
  | (_, #second, #"from now") => "잠시후"
  | (1, #day, #"from now") => "내일"
  | (2, #day, #"from now") => "모레"
  | (1, #week, #"from now") => "다음주"
  | (1, #month, #"from now") => "다음달"
  | (1, #year, #"from now") => "내년"
  | _ =>
    let value = value->Int.toString
    let unit = switch unit {
    | #second => "초"
    | #minute => "분"
    | #hour => "시간"
    | #day => "일"
    | #week => "주"
    | #month => "달"
    | #year => "년"
    }
    let suffix = switch suffix {
    | #ago => "전"
    | #"from now" => "후"
    }
    `${value}${unit} ${suffix}`
  }
}

let formatDate = date => {
  let date = date->Date.fromString
  let year = date->Date.getFullYear->Int.toString
  let month = (date->Date.getMonth + 1)->Int.toString
  let day = date->Date.getDate->Int.toString
  `${year}년 ${month}월 ${day}일`
}

let formatTitle = date => {
  let padZero = value => {
    if value < 10 {
      `0${value->Int.toString}`
    } else {
      value->Int.toString
    }
  }
  let date = date->Date.fromString
  let year = date->Date.getFullYear->Int.toString
  let month = (date->Date.getMonth + 1)->padZero
  let day = date->Date.getDate->padZero
  let hour = date->Date.getHours->padZero
  let minute = date->Date.getMinutes->padZero
  let second = date->Date.getSeconds->padZero
  `${year}-${month}-${day} ${hour}:${minute}:${second}`
}

@react.component
let make = (~children, ~className=?) => {
  let now = Now.useSync()
  let date = React.useMemo(() => children->Date.fromString, [children])
  let title = React.useMemo(() => formatTitle(children), [children])
  if now -. date->Date.getTime < (7 * 24 * 60 * 60 * 1000)->Int.toFloat {
    <TimeAgo date formatter now title suppressHydrationWarning={true} ?className />
  } else {
    <time dateTime={date->Js.Date.toISOString} title={title} ?className>
      {formatDate(children)->React.string}
    </time>
  }
}
