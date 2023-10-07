open Tyxml

let render (children: 'a Html.elt): [> Html_types.html] Html.elt =
  [%html {html|<!DOCTYPE html>
<head>
<meta charset="utf-8">
<title>Quick QR</title>
</head>
<body>|html}
[children]
{html|</body>|html}]
