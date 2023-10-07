module Make(): Rest_api.Handler.T = struct
  let route = Dream.get "/dist.css" @@ 
    Dream.from_filesystem "." "dist.css"
end
