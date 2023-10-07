module type T = sig
  val handlers: (module Handler.T) list
end
