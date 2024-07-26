let metadata: {..} = {
  "title": {
    "template": "%s | 왼손잡이해방연대 아지트",
    "default": "왼손잡이해방연대 아지트",
  },
  "description": "오른손도 자주 씁니다",
}

@react.component
let default = (~children) => {
  <html lang="ko">
    <head>
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
      />
    </head>
    <body> {children} </body>
    <InitToken />
  </html>
}
