module Make(Handlers: Rest_api.Handlers.T): Rest_api.Server.T = struct
  let listen ~(port:int) = 
    Dream.run ~port
    @@ Dream.logger
    @@ Dream.router 
    @@ List.map (fun ((module Handler): (module Rest_api.Handler.T)) -> Handler.route) Handlers.handlers
end
