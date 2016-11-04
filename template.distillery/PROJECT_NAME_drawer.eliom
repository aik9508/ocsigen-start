(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

[%%shared
   open Eliom_content.Html
   open Eliom_content.Html.F
]

(** This modules defines the drawer menu *)

let%shared item text service =
  li [ a ~a:[ a_class ["os-drawer-item"] ] ~service [pcdata text] () ]

let%shared user_menu () =
  [ item "Settings" %%%MODULE_NAME%%%_services.settings_service
  ; Eliom_content.Html.F.li
      [ %%%MODULE_NAME%%%_userbox.disconnect_link ~a:[ a_class ["os-drawer-item"] ] () ]
  ]

let%shared make ?user () =
  let items =
    if user = None
    then []
    else user_menu ()
  in
  let items =
    item "Home" Os_services.main_service
    :: item "About" %%%MODULE_NAME%%%_services.about_service
    :: Demo_tools.drawer_contents ()
    :: items
  in
  let menu = ul ~a:[a_class ["os-drawer-menu"]] items in
  let contents = match user with
    | None -> [ menu ]
    | Some user ->
      let user_box = %%%MODULE_NAME%%%_userbox.connected_user_box ~user in
      [ user_box ; menu ]
  in
  let drawer, _, _ = Ot_drawer.drawer contents in
  drawer