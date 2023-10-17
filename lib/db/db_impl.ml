module Make (Config : Db_api.Config.T) : Db_api.Db.T = struct
  type t = Sqlite3.db

  let connection : t = Sqlite3.db_open Config.database_url
end
