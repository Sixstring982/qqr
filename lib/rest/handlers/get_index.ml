module Make(): Rest_api.Handler.T = struct
  let route = Dream.get "/" @@ fun _ -> 
    Dream.html @@ Fmt.str "%a" (Tyxml.Html.pp ()) @@ Ui.Base_html.render Ui.Navbar.render
end
