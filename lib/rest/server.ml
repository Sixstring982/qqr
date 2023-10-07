module type T = sig
  val listen: port:int -> unit
end
