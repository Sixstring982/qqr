open Tyxml

let render (children: 'a Html.elt list): [> Html_types.html] Html.elt =
  [%html {html|<!DOCTYPE html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="/dist.css">
<title>Quick QR</title>
</head>
<body class="bg-slate-800">|html}
children
{html|</body>|html}]
