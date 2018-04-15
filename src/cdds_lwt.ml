
open Lwt.Infix

let lwt_cdds_wrap_1 op arg1 = Lwt_preemptive.detach (fun _ -> op arg1) ()
let lwt_cdds_wrap_2 op arg1 arg2 = Lwt_preemptive.detach (fun _ -> op arg1 arg2) ()
let lwt_cdds_wrap_3 op arg1 arg2 arg3 = Lwt_preemptive.detach (fun _ -> op arg1 arg2 arg3) ()
let lwt_cdds_wrap_4 op arg1 arg2 arg3 arg4 = Lwt_preemptive.detach (fun _ -> op arg1 arg2 arg3 arg4) ()
let lwt_cdds_wrap_5 op arg1 arg2 arg3 arg4 arg5 = Lwt_preemptive.detach (fun _ -> op arg1 arg2 arg3 arg4 arg5) ()
let lwt_cdds_wrap_6 op arg1 arg2 arg3 arg4 arg5 arg6 = Lwt_preemptive.detach (fun _ -> op arg1 arg2 arg3 arg4 arg5 arg6) ()
let lwt_cdds_wrap_7 op arg1 arg2 arg3 arg4 arg5 arg6 arg7 = Lwt_preemptive.detach (fun _ -> op arg1 arg2 arg3 arg4 arg5 arg6 arg7) ()

module Time = Cdds.Time
module Duration = Cdds.Duration
module DomainId = Cdds.DomainId
module InstanceHandle = Cdds.InstanceHandle
module SampleState = Cdds.SampleState
module ViewState = Cdds.ViewState
module InstanceState = Cdds.InstanceState
module SampleInfo = Cdds.SampleInfo

module Participant = struct
  type t = Cdds.Entity.t Lwt.t
  let make did   = Lwt.return @@ Cdds.Participant.make did
  let parent leid = leid >>= fun eid -> Lwt.return @@ Cdds.Participant.parent eid
  let participant leid = leid >>= fun eid -> Lwt.return @@ Cdds.Participant.participant eid
end

module Topic = struct
  type t = Cdds.Entity.t Lwt.t
  let make ?(policies=[]) ldp name  =
    ldp >>= fun dp -> Lwt.return @@ Cdds.Topic.make ~policies:policies dp name

  let find ldp name =
    ldp >>= fun dp -> Lwt.return @@ Cdds.Topic.find dp name
end


module Publisher = struct
  type t = Cdds.Entity.t Lwt.t

  let default ldp = ldp >>= fun dp -> Lwt.return @@ Cdds.Publisher.default dp

  let make ?(policies=[]) ldp =
    ldp >>= fun dp ->
      Lwt.return @@ Cdds.Publisher.make ~policies:policies dp

  let get leid = leid >>= fun eid -> Lwt.return @@ Cdds.Publisher.get eid
end

module Subscriber = struct
  type t = Cdds.Entity.t Lwt.t

  let default ldp = ldp >>= fun dp -> Lwt.return @@ Cdds.Subscriber.default dp

  let make ?(policies=[]) ldp =
    ldp >>= fun dp ->
    Lwt.return @@ Cdds.Subscriber.make ~policies:policies dp

  let get leid = leid >>= fun eid -> Lwt.return @@ Cdds.Subscriber.get eid
end

module Writer = struct
  type t = Cdds.Entity.t Lwt.t

  let make ?(policies=Cdds.QosPattern.state) lpub ltopic =
    lpub >>= fun pub ->
    ltopic >>= fun topic ->
    Lwt.return @@ Cdds.Writer.make ~policies:policies pub topic

  let write_string ldw key value =
    ldw >>= fun dw -> Lwt.return @@ Cdds.Writer.write_string dw key value

  let write ldw key bs =
    ldw >>= fun dw -> Lwt.return @@ Cdds.Writer.write dw key bs

  let write_list ldw ksvs =
    ldw >>= fun dw -> Lwt.return @@ Cdds.Writer.write_list dw ksvs
end

module Reader = struct
  type t = Cdds.Entity.t Lwt.t

  let make ?(max_samples=128) ?(policies=Cdds.QosPattern.state) lsub ltopic =
    lsub >>= fun sub ->
    ltopic >>= fun topic ->
      Lwt.return @@ (Cdds.Reader.make ~max_samples:max_samples ~policies:policies sub topic)

  let read ldr = ldr >>= fun dr -> Lwt.return @@ Cdds.Reader.read dr
  let take ldr = ldr >>= fun dr -> Lwt.return @@ Cdds.Reader.take dr

  let read_n ldr n = ldr >>= fun dr -> Lwt.return @@  Cdds.Reader.read_n dr n
  let take_n ldr n = ldr >>= fun dr -> Lwt.return @@  Cdds.Reader.take_n dr n

  let selective_read sel ldr = ldr >>= fun dr -> Lwt.return @@ Cdds.Reader.selective_read sel dr
  let selective_take sel ldr = ldr >>= fun dr -> Lwt.return @@ Cdds.Reader.selective_take sel dr

  (** sread and stake are run detached to ensure that they don't block the main
  thread *)
  let sread ldr timeout = ldr >>= fun dr -> lwt_cdds_wrap_2 Cdds.Reader.sread dr timeout
  let stake ldr timeout = ldr >>= fun dr -> lwt_cdds_wrap_2 Cdds.Reader.stake dr timeout

  let selective_sread sel ldr timeout = ldr >>= fun dr -> lwt_cdds_wrap_3 Cdds.Reader.selective_sread sel dr timeout
  let selective_stake sel ldr timeout = ldr >>= fun dr -> lwt_cdds_wrap_3 Cdds.Reader.selective_stake sel dr timeout

end
