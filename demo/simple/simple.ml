open Cdds_lwt
open Lwt.Infix

let dp = Participant.make DomainId.default
let name = "KeyValue"
let topic = Topic.make dp name
let pub = Publisher.make dp
let sub = Subscriber.make dp
let dr = Reader.make sub topic
let read_loop () =
  let rec make_n_comp n cs =
    let data = Cdds_lwt.Reader.sread dr Duration.infinity in
    let comp = data >>= (fun s -> List.iter (fun ((k,v),_) -> let _ = Lwt_io.printf "[%d]>> key: %s, value: %s\n" n k (Bytes.to_string v) in ()) s; Lwt.return_unit ) in
    if n = 0 then cs else make_n_comp (n-1 )(comp :: cs)
  in
  let comps = make_n_comp 10000 [] in
  Lwt.join comps

let _ = Lwt_main.run @@ read_loop ()
