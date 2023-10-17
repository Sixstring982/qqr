open Import
open Tyxml

let node deps : ('context, [> Html_types.html ] Html.elt, 'e) Producer.Node.t =
  Producer.Node.make deps @@ fun _context navbar children ->
    Base_html.render @@ List.concat [navbar; children]
