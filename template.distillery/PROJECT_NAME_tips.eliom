(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

(* Here is an example of tip. Call this function while generating the
   widget concerned by the explanation it contains. *)
let example_tip () =
  Os_tips.bubble ()
    ~top:40 ~right:0 ~width:300 ~height:120
    ~arrow:(`top 300)
    ~name:"example"
    ~content:(fun _ ->
      Lwt.return
        Eliom_content.Html.F.[
          p [%i18n example_tip];
          p [%i18n look_module_tip]
        ])
