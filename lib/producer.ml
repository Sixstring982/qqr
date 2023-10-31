module type MONAD = sig
  type 'a t

  val return : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type MONAD2 = sig
  type ('a, 'b) t

  val return : 'a -> ('a, 'b) t
  val bind : ('a, 'b) t -> ('a -> ('c, 'b) t) -> ('c, 'b) t
end

exception Cyclic

module Make (M : MONAD) = struct
  let ( let* ) = M.bind
  let ( =<< ) fn x = M.bind x fn

  module Types = struct
    module rec Graph : sig
      type 'output t = { execute : unit -> 'output M.t }
    end =
      Graph

    and Execution_cache : sig
      type t = { outputs_by_key : Hmap.t }
    end =
      Execution_cache

    and Token : sig
      type _ t =
        | Input : string * 'a Hmap.key -> 'a t
        | Node : string * 'a Hmap.key * 'a Node.t Hmap.key -> 'a t
    end =
      Token

    and Dependencies : sig
      type (_, _) t =
        | [] : ('output, 'output) t
        | ( :: ) : 'a Token.t * ('b, 'output) t -> ('a -> 'b, 'output) t
    end =
      Dependencies

    and Node : sig
      type 'output t =
        | Node : {
            dependencies : ('deps, 'output M.t) Dependencies.t;
            produce : unit -> 'deps;
          }
            -> 'output t
    end =
      Node
  end

  module Dependencies = struct
    include Types.Dependencies
  end

  module Token = struct
    include Types.Token

    let input label = Input (label, Hmap.Key.create ())
    let node label = Node (label, Hmap.Key.create (), Hmap.Key.create ())
  end

  module type REGISTRY_HELPER = sig
    val bind_input : 'a Token.t -> 'a -> Hmap.t -> Hmap.t
    val bind_node : 'a Token.t -> 'a Types.Node.t -> Hmap.t -> Hmap.t
  end

  module Registry_helper : REGISTRY_HELPER = struct
    let bind_input token =
      match token with
      | Token.Input (_, k) -> fun v -> Hmap.add k v
      | Token.Node _ -> failwith "bind_input called with Node!"

    let bind_node token =
      match token with
      | Token.Node (_, _, k) -> fun v -> Hmap.add k v
      | Token.Input _ -> failwith "bind_node called with Input!"
  end

  module type REGISTRY = sig
    val bindings : (module REGISTRY_HELPER) -> Hmap.t -> Hmap.t
  end

  module Container (I : sig
    val registries : (module REGISTRY) list
  end) =
  struct
    let bindings =
      let _bindings =
        List.map
          (fun (module M : REGISTRY) -> M.bindings (module Registry_helper))
          I.registries
      in
      Hmap.empty
  end

  module Node = struct
    include Types.Node
    module Dependencies = Types.Dependencies

    let make (dependencies : ('deps, 'output M.t) Dependencies.t)
        (produce : unit -> 'deps) : 'output t =
      Node { dependencies; produce }
  end

  module Graph = struct
    include Types.Graph
    module Execution_cache = Types.Execution_cache

    let rec execute_node :
        type deps output.
        Hmap.t ->
        Execution_cache.t ->
        (deps, output) Dependencies.t ->
        deps ->
        (output * Execution_cache.t) M.t =
     fun container cache deps f ->
      match deps with
      | [] -> M.return (f, cache)
      | Input (label, key) :: xs -> (
          match Hmap.find key container with
          | None -> failwith @@ {|Missing container binding: "|} ^ label ^ {|"|}
          | Some input -> execute_node container cache xs (f input))
      | Node (label, cache_key, key) :: xs -> (
          match Hmap.find cache_key cache.outputs_by_key with
          (* If a node output has already been produced and is cached, use that value. *)
          | Some output -> execute_node container cache xs (f output)
          (* Otherwise, we need to compute the output for that node. *)
          | None -> (
              match Hmap.find key container with
              | None ->
                  failwith @@ {|Missing container binding: "|} ^ label ^ {|"|}
              | Some (Node node) ->
                  let* output, cache =
                    execute_node container cache node.dependencies
                    @@ node.produce ()
                  in
                  let* output = output in
                  let cache : Execution_cache.t =
                    {
                      outputs_by_key =
                        Hmap.add cache_key output cache.outputs_by_key;
                    }
                  in
                  execute_node container cache xs (f output)))

    let execute (container : Hmap.t)
        (Node { dependencies; produce } : 'output Node.t) : 'output M.t =
      let cache : Execution_cache.t = { outputs_by_key = Hmap.empty } in
      fst =<< execute_node container cache dependencies @@ produce ()
  end
end

module Sync : MONAD with type 'a t = 'a = struct
  type 'a t = 'a

  let return a = a
  let bind a fn = fn a
end

include Make (Sync)
