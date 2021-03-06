open Cdds_lwt
open Lwt.Infix


let dp = Participant.make DomainId.default
let name = "KeyValue"
let topic = Topic.make dp name

let reader () =
  let sub = Subscriber.make dp in
  let dr = Reader.make sub topic in
  let rec read_data r =
    let%lwt data = Cdds_lwt.Reader.sread r in
    List.iter (fun ((k,v), _) ->
        ignore @@ Lwt_io.printf ">>> key: %s, value: %s\n" k (Bytes.to_string v);
      )
        data;
    read_data dr
  in
  Lwt_main.run @@ read_data dr

let writer () =
  let b = Bytes.make 1500 'A' in
  let pub = Publisher.make dp in
  let w = Writer.make pub topic in
  let rec write_data w n =
    let k = "ocaml" ^ (string_of_int (n mod 10)) in
    let v = (Bytes.unsafe_to_string b) ^ "-rulez-" ^ (string_of_int n) in
    let%lwt r = Writer.write_string w k v in
    (* let _ = Lwt_io.printf "Write %d returned %d\n" n @@ Int32.to_int r in (); *)
    (* Unix.sleepf 0.1; *)
    write_data w @@ n - 1
  in
  Lwt_main.run @@ write_data w 10000


  let writer_alloc () =
    let b = Bytes.make 1500 'A' in
    let pub = Publisher.make dp in
    let w = Writer.make pub topic in
    let rec write_data w n =
      let k = "ocaml" ^ (string_of_int (n mod 10)) in
      let v = (Bytes.to_string b) ^ "-rulez-" ^ (string_of_int n) in
      let%lwt r = Writer.write_alloc w k (Bytes.of_string v) in
      (* let _ = Lwt_io.printf "Write %d returned %d\n" n @@ Int32.to_int r in (); *)
      (* Unix.sleepf 0.1; *)
      write_data w @@ n - 1
    in
      Lwt_main.run @@ write_data w 10000




let usage () = ignore( print_endline "USAGE:\n\t simple <pub | pub-alloc | sub>" )


let _ =
  let argv = Sys.argv in
  if Array.length argv < 2 then usage ()
  else
  match Array.get argv 1 with
    | "pub" -> writer ()
    | "pub-alloc" -> writer_alloc ()
    | "sub" -> reader ()
    | _ -> usage ()
