open Import

module Make () = struct
  type t = { id : Uuidm.t; email : string }

  module Q = struct
    open Caqti_request.Infix
    open Caqti_type.Std

    let uuid : Uuidm.t Caqti_type.t =
      Caqti_type.custom
        ~encode:(fun s -> Ok (Uuidm.to_string s))
        ~decode:(fun s ->
          Option.to_result ~none:(Fmt.str "Invalid UUID: %s" s)
          @@ Uuidm.of_string s)
        string

    let password_hash : Bcrypt.hash Caqti_type.t =
      Caqti_type.custom
        ~encode:(fun s -> Ok (Bcrypt.string_of_hash s))
        ~decode:(fun s -> Ok (Bcrypt.hash_of_string s))
        string

    let id_for_email =
      (string ->? uuid)
      @@ {sql|SELECT `id`
           FROM `user`
           WHERE `email` = ?
      |sql}

    let id_for_email_and_password =
      (tup2 string string ->? uuid)
      @@ {sql|SELECT `id`
              FROM `user`
              WHERE `email` = ?
                AND `password_hash` = ?
         |sql}

    let create =
      (tup3 uuid string password_hash ->. unit)
      @@ {sql|INSERT INTO `user`
              VALUES (
                `id` = ?
              , `email` = ?
              , `password_hash` = ?
              )
         |sql}
  end

  module Nodes = struct
    let for_email deps : ('context, t option, 'e) Producer.Node.t =
      Producer.Node.make deps @@ fun context ->
      let module Db = (val context#db : Caqti_lwt.CONNECTION) in
      let email = context#email in
      let* id = Db.find_opt Q.id_for_email email in
      match id with
      | None -> Lwt_result.return None
      | Some id -> Lwt_result.return (Some { id; email })

    let id_for_email deps : ('context, Uuidm.t option, 'e) Producer.Node.t =
      Producer.Node.make deps @@ fun _context (user : t option) ->
      match user with
      | None -> Lwt_result.return None
      | Some user -> Lwt_result.return @@ Some user.id

    let create deps : ('context, t, 'e) Producer.Node.t =
      Producer.Node.make deps @@ fun context (user : t option) ->
      let module Db = (val context#db : Caqti_lwt.CONNECTION) in
      match user with
      | Some user -> Lwt_result.fail @@ `User_exists user
      | None ->
          let email = context#email in
          let password = context#password in
          let id = Uuidm.v4_gen (Random.State.make_self_init ()) () in
          let password_hash = Bcrypt.hash password in
          let* () = Db.exec Q.create (id, email, password_hash) in
          Lwt_result.return @@ { id; email }
  end
end
