open Import
open Tyxml

let node deps : ('context, [> Html_types.nav ] Html.elt, 'e) Producer.Node.t =
  Producer.Node.make deps @@ fun _context user ->
  Lwt_result.return
  @@ [%html
       {html|
<nav class="h-10 p-2 bg-red-500 flex justify-between items-center">
  <a href="/">
    Logo
  </a>
  <div class="flex gap-2">|html}
         [
           (match user with
           | Some _ -> [%html {html|<a href="/session/new">Log in</a>|html}]
           | None -> [%html {html|<a href="/session/new">Log out</a>|html}]);
         ]
         {html|
  </div>
</nav>
|html}]
