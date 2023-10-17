module Make (Handlers : Rest_api.Handlers.T) (Db_config : Db_api.Config.T) :
  Rest_api.Server.T = struct
  let listen ~(port : int) =
    Dream.run ~port @@ Dream.logger
    @@ Dream.sql_pool Db_config.database_url
    @@ Dream.router
    @@ List.map
         (fun (module Handler : Rest_api.Handler.T) -> Handler.route)
         Handlers.handlers
end
