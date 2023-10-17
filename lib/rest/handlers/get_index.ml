open Import

module Make (User : Db_api.User.T) : Rest_api.Handler.T = struct
  let graph =
    let user_opt = User.for_request [] in
    let navbar = Ui.Navbar.node [ user_opt ] in
    let layout = Ui.Layout.node [ navbar; navbar ] in
    Producer.Graph.make

  let route =
    Dream.get "/" @@ fun _ ->
    Dream.html @@ Fmt.str "%a" (Tyxml.Html.pp ()) @@ Ui.Layout.render []
end
