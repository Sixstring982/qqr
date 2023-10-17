open Import

module type T = sig
  type t = { id : Uuidm.t; email : string }

  val for_request :
    ( < db : (module Caqti_lwt.CONNECTION) ; request : Dream.request ; .. >,
      (t option, [> Caqti_error.call_or_retrieve ]) Lwt_result.t,
      (t option, 'e) Lwt_result.t,
      'e )
    Producer.Dependencies.t ->
    ('a, t option, 'e) Producer.Node.t

  val for_email :
    ( < db : (module Caqti_lwt.CONNECTION) ; email : string ; .. >,
      (t option, [> Caqti_error.call_or_retrieve ]) Lwt_result.t,
      (t option, 'e) Lwt_result.t,
      'e )
    Producer.Dependencies.t ->
    ('a, t option, 'e) Producer.Node.t
end
