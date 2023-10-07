open Tyxml

let render: [> Html_types.nav] Html.elt =
[%html {html|
<nav class="h-10 p-2 bg-red-500 flex justify-between items-center">
  <a href="/">
    Logo
  </a>
  <div class="flex gap-2">
    <a href="/session/new">
      Log in
    </a>
  </div>
</nav>
|html}]
