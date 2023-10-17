module type T = sig
  type t = Sqlite3.db

  val connection: t
end
