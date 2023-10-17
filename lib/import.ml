module Producer = Producer.Make2 (Lwt_result)

let ( let- ) = Option.bind
let ( let* ) = Lwt_result.bind
let ( let+ ) = Lwt.bind
let ( let@ ) = Result.bind
