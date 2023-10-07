module Rest = struct
  module Handlers: Rest_api.Handlers.T = struct
    let handlers = [
      (module Rest_handlers.Get_dist_css.Make(): Rest_api.Handler.T);
      (module Rest_handlers.Get_index.Make(): Rest_api.Handler.T);
      (module Rest_handlers.Get_session_new.Make(): Rest_api.Handler.T);
    ]
  end
  module Server: Rest_api.Server.T = Rest_impl.Server_impl.Make(Handlers)
end
