module Make () : Rest_api.Handler.T = struct
  let route = Dream.get "/session/new" @@ fun _ -> Dream.html "foo"
end
