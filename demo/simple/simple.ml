open Cdds_lwt
open Lwt.Infix

let _ =
  let dp = Participant.make DomainId.default in
  let name = "KeyValue" in
  let topic = Topic.make dp name in
  let sub = Subscriber.make dp in
  let dr = Reader.make sub topic in

  let rec read_data r =
    let%lwt data = Cdds_lwt.Reader.sread r Duration.infinity in
    List.iter (fun ((k,v),_) -> let _ = Lwt_io.printf ">>> key: %s, value: %s\n" k (Bytes.to_string v) in ()) data ;
    read_data dr
  in Lwt_main.run @@ read_data dr
