(* Ocsigen-start
 * http://www.ocsigen.org/ocsigen-start
 *
 * Copyright (C) Université Paris Diderot, CNRS, INRIA, Be Sport.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

[%%shared
  open Eliom_content.Html
  open Eliom_content.Html.F
]

let%client check_password_confirmation ~password ~confirmation =
  let password_dom = To_dom.of_input password in
  let confirmation_dom = To_dom.of_input confirmation in
  Lwt_js_events.async
    (fun () ->
       Lwt_js_events.inputs confirmation_dom
         (fun _ _ ->
            ignore
              (if Js.to_string password_dom##.value <> Js.to_string
              confirmation_dom##.value
               then
                 (Js.Unsafe.coerce
                    confirmation_dom)##(setCustomValidity ("Passwords do not match"))
               else (Js.Unsafe.coerce confirmation_dom)##(setCustomValidity ("")));
            Lwt.return ()))

let%shared generic_email_form
    ?a
    ?label
    ?(a_placeholder_email="e-mail address")
    ?(text="Send")
    ?(email="")
    ~service
    () =
  D.Form.post_form ?a ~service
    (fun name ->
      let l = [
        Form.input
          ~a:[a_placeholder a_placeholder_email]
          ~input_type:`Email
          ~value:email
          ~name
          Form.string;
        Form.input
          ~a:[a_class ["button"]]
          ~input_type:`Submit
          ~value:text
          Form.string;
      ]
      in
      match label with
      | None -> l
      | Some lab -> F.label [pcdata lab]::l) ()

let%shared connect_form
    ?(a_placeholder_email="Your email")
    ?(a_placeholder_pwd="Your password")
    ?(text_keep_me_logged_in="keep me logged in")
    ?(text_sign_in="Sign in")
    ?a
    ?(email="")
    () =
  D.Form.post_form ?a ~service:Os_services.connect_service
    (fun ((login, password), keepmeloggedin) ->
       [ Form.input
           ~a:[a_placeholder a_placeholder_email]
           ~name:login
           ~input_type:`Email
           ~value:email
           Form.string
       ; Form.input
           ~a:[a_placeholder a_placeholder_pwd]
           ~name:password
           ~input_type:`Password
           Form.string
       ; label [ Form.bool_checkbox_one
                   ~a:[a_checked ()]
                   ~name:keepmeloggedin
                   ()
               ; pcdata text_keep_me_logged_in]
       ; Form.input
           ~a:[a_class ["button" ; "os-sign-in"]]
           ~input_type:`Submit
           ~value:text_sign_in
           Form.string
       ]) ()

let%shared disconnect_button ?a ?(text_logout="Logout") () =
  Form.post_form ?a ~service:Os_services.disconnect_service
    (fun _ -> [
         Form.button_no_value
           ~a:[ a_class ["button"] ]
           ~button_type:`Submit
           [Os_icons.F.signout (); pcdata text_logout]
       ]) ()

let%shared sign_up_form ?a ?a_placeholder_email ?text ?email () =
  generic_email_form
    ?a
    ?a_placeholder_email
    ?text
    ?email
    ~service:Os_services.sign_up_service
    ()

let%shared forgot_password_form ?a () =
  generic_email_form ?a
    ~service:Os_services.forgot_password_service ()

let%shared information_form
    ?a
    ?(a_placeholder_password="Your password")
    ?(a_placeholder_retype_password="Retype password")
    ?(a_placeholder_firstname="Your first name")
    ?(a_placeholder_lastname="Your last name")
    ?(text_submit="Submit")
    ?(firstname="")
    ?(lastname="")
    ?(password1="")
    ?(password2="")
    () =
  D.Form.post_form ?a ~service:Os_services.set_personal_data_service
    (fun ((fname, lname), (passwordn1, passwordn2)) ->
       let pass1 = D.Form.input
           ~a:[a_placeholder a_placeholder_password]
           ~name:passwordn1
           ~value:password1
           ~input_type:`Password
           Form.string
       in
       let pass2 = D.Form.input
           ~a:[a_placeholder a_placeholder_retype_password]
           ~name:passwordn2
           ~value:password2
           ~input_type:`Password
           Form.string
       in
       let _ = [%client (
         check_password_confirmation ~password:~%pass1 ~confirmation:~%pass2
       : unit)]
       in
       [
         Form.input
           ~a:[a_placeholder a_placeholder_firstname]
           ~name:fname
           ~value:firstname
           ~input_type:`Text
           Form.string;
         Form.input
           ~a:[a_placeholder a_placeholder_lastname]
           ~name:lname
           ~value:lastname
           ~input_type:`Text
           Form.string;
         pass1;
         pass2;
         Form.input
           ~a:[a_class ["button"]]
           ~input_type:`Submit
           ~value:text_submit
           Form.string;
       ]) ()

let%shared preregister_form ?a label =
  generic_email_form ?a ~service:Os_services.preregister_service ~label ()

let%shared home_button ?a () =
  Form.get_form ?a ~service:Os_services.main_service
    (fun _ -> [
      Form.input
        ~input_type:`Submit
        ~value:"home"
        Form.string;
    ])

let%shared avatar user =
  match Os_user.avatar_uri_of_user user with
  | Some src ->
    img ~alt:"picture" ~a:[a_class ["os-avatar"]] ~src ()
  | None -> Os_icons.F.user ()

let%shared username user =
  let n = match Os_user.firstname_of_user user with
    | "" ->
      let userid = Os_user.userid_of_user user in
      [pcdata ("User "^Int64.to_string userid)]
    | s ->
      [pcdata s;
       pcdata " ";
       pcdata (Os_user.lastname_of_user user);
      ]
  in
  div ~a:[a_class ["os_username"]] n

let%shared password_form
    ?(a_placeholder_pwd="password")
    ?(a_placeholder_confirmation="retype your password")
    ?(text_send_button="Send")
    ?a
    ~service
    () =
  D.Form.post_form
    ?a
    ~service
    (fun (pwdn, pwd2n) ->
       let pass1 =
         D.Form.input
           ~a:[a_required ();
               a_autocomplete false;
               a_placeholder a_placeholder_pwd]
           ~input_type:`Password
           ~name:pwdn
           Form.string
       in
       let pass2 =
         D.Form.input
           ~a:[a_required ();
               a_autocomplete false;
               a_placeholder a_placeholder_confirmation]
           ~input_type:`Password
           ~name:pwd2n
           Form.string
       in
       ignore [%client (
        check_password_confirmation ~password:~%pass1 ~confirmation:~%pass2
       : unit)];
       [ pass1
       ; pass2
       ; Form.input
           ~input_type:`Submit
           ~a:[ a_class ["button" ] ]
           ~value:text_send_button
           Form.string
       ])
    ()

let%shared upload_pic_link
    ?(a = [])
    ?(content=[pcdata "Change profile picture"])
    ?(crop = Some 1.)
    ?(input :
      Html_types.label_attrib Eliom_content.Html.D.Raw.attrib list
      * Html_types.label_content_fun Eliom_content.Html.D.Raw.elt list
      = [], []
    )
    ?(submit :
      Html_types.button_attrib Eliom_content.Html.D.Raw.attrib list
      * Html_types.button_content_fun Eliom_content.Html.D.Raw.elt list
      = [], [pcdata "Submit"]
    )
    ?(onclick : (unit -> unit) Eliom_client_value.t = [%client (fun () -> () : unit -> unit)])
    (service : (unit, unit) Ot_picture_uploader.service)
  =
  D.Raw.a ~a:( a_onclick [%client (fun ev -> Lwt.async (fun () ->
    ~%onclick () ;
    let upload_service ?progress ?cropping file =
      Ot_picture_uploader.ocaml_service_upload
        ?progress ?cropping ~service:~%service ~arg:() file
    in
    try%lwt ignore @@
      Ot_popup.popup
        ~close_button:[ Os_icons.F.close () ]
        ~onclose:(fun () ->
          Eliom_client.change_page
            ~service:Eliom_service.reload_action () ())
        (fun close -> Ot_picture_uploader.mk_form
            ~crop:~%crop ~input:~%input ~submit:~%submit
            ~after_submit:close upload_service) ;
      Lwt.return ()
    with e ->
      Os_msg.msg ~level:`Err "Error while uploading the picture";
      Eliom_lib.debug_exn "%s" e "→ ";
      Lwt.return () ) : _ ) ] :: a) content

let%shared reset_tips_link
    ?(text_link="See help again from beginning")
    ?(close : (unit -> unit) Eliom_client_value.t = [%client (fun () -> () : unit -> unit)]) ()
  =
  let l = D.Raw.a [pcdata text_link] in
  ignore [%client (
    Lwt_js_events.(async (fun () ->
      clicks (To_dom.of_element ~%l)
        (fun _ _ ->
           ~%close ();
           Eliom_client.exit_to
             ~service:Os_tips.reset_tips_service
             () ();
           Lwt.return ()
        )));
  : unit)];
  l

let%shared bind_popup_button
    ?a
    ~button
    ~(popup_content : ((unit -> unit Lwt.t) -> [< Html_types.div_content ]
                         Eliom_content.Html.elt Lwt.t) Eliom_client_value.t)
    ()
  =
  ignore
    [%client
      (Lwt.async (fun () ->
         Lwt_js_events.clicks
           (Eliom_content.Html.To_dom.of_element ~%button)
           (fun _ _ ->
              let%lwt _ =
                Ot_popup.popup
                  ?a:~%a
                  ~close_button:[ Os_icons.F.close () ]
                  ~%popup_content
              in
              Lwt.return ()))
       : _)
    ]

let%shared forgotpwd_button
    ?(content_popup="Recover password")
    ?(text_button="Forgot your password?")
    ?(close = [%client (fun () -> () : unit -> unit)])
    () =
  let popup_content = [%client fun _ -> Lwt.return @@
    div [ h2 [ pcdata ~%content_popup ]
        ; forgot_password_form ()] ]
  in
  let button_name = text_button in
  let button = D.Raw.a ~a:[ a_class ["os-forgot-pwd-link"]
                          ; a_onclick [%client fun _ -> ~%close () ] ]
      [pcdata button_name]
  in
  bind_popup_button
    ~a:[a_class ["os-forgot-pwd"]]
    ~button
    ~popup_content
    ();
  button

let%shared sign_in_button
    ?(a_placeholder_email="Your email")
    ?(a_placeholder_pwd="Your password")
    ?(text_keep_me_logged_in="keep me logged in")
    ?(text_sign_in="Sign in")
    ?(content_popup_forgotpwd="Recover password")
    ?(text_button_forgotpwd="Forgot your password?")
    ?(text_button="Sign in")
    () =
  let popup_content = [%client fun close -> Lwt.return @@
    div [ h2 [ pcdata ~%text_button ]
        ; connect_form
            ~a_placeholder_email:~%a_placeholder_email
            ~a_placeholder_pwd:~%a_placeholder_pwd
            ~text_keep_me_logged_in:~%text_keep_me_logged_in
            ~text_sign_in:~%text_sign_in
            ()
        ; forgotpwd_button
            ~content_popup:~%content_popup_forgotpwd
            ~text_button:~%text_button_forgotpwd
            ~close:(fun () -> Lwt.async close) ()
        ] ]
  in
  let button_name = text_button in
  let button =
    D.button ~a:[a_class ["button" ; "os-sign-in-btn"]] [pcdata button_name]
  in
  bind_popup_button
    ~a:[a_class ["os-sign-in"]]
    ~button
    ~popup_content
    ();
  button

let%shared sign_up_button
    ?(a_placeholder_email="Your email")
    ?(text_button="Sign up")
    ?(text_send_button="Send")
    () =
  let popup_content = [%client fun _ -> Lwt.return @@
    div [ h2 [ pcdata ~%text_button ]
        ; sign_up_form
            ~a_placeholder_email:~%a_placeholder_email
            ~text:~%text_send_button
            ()
        ]
  ]
  in
  let button_name = text_button in
  let button =
    D.button ~a:[a_class ["button" ; "os-sign-up-btn"]] [pcdata button_name]
  in
  bind_popup_button
    ~a:[a_class ["os-sign-up"]]
    ~button
    ~popup_content
    ();
  button

let%shared disconnect_button
    ?(text_logout="Logout")
    () =
  D.Form.post_form ~service:Os_services.disconnect_service
    (fun _ -> [
         Form.button_no_value
           ~a:[ a_class ["button"] ]
           ~button_type:`Submit
           [ Os_icons.F.signout (); pcdata text_logout]
       ]) ()

let%shared disconnect_link
    ?(text_logout="Logout")
    ?(a = [])
    () =
  Eliom_content.Html.D.Raw.a
    ~a:(a_onclick [%client fun _ ->
      Lwt.async (fun () ->
        Eliom_client.change_page ~service:Os_services.disconnect_service () ())
    ]
        ::a)
    [ Os_icons.F.signout (); pcdata text_logout]

let%shared connected_user_box ~user =
  let username = username user in
  D.div ~a:[a_class ["connected-user-box"]]
    [ avatar user
    ; div [ username ]
    ]

let%shared connection_box
    ?(a_placeholder_email="Your email")
    ?(a_placeholder_pwd="Your password")
    ?(text_keep_me_logged_in="keep me logged in")
    ?(content_popup_forgotpwd="Recover password")
    ?(text_button_forgotpwd="Forgot your password?")
    ?(text_sign_in="Sign in")
    ?(text_sign_up="Sign up")
    ?(text_send_button="Send")
    ()
  =
  let sign_in    =
    sign_in_button
      ~a_placeholder_email
      ~a_placeholder_pwd
      ~text_keep_me_logged_in
      ~text_sign_in
      ~content_popup_forgotpwd
      ~text_button_forgotpwd
      ~text_button:text_sign_in
      ()
  in
  let sign_up    =
    sign_up_button
      ~a_placeholder_email
      ~text_button:text_sign_up
      ~text_send_button
      ()
  in
  Lwt.return @@ div ~a:[ a_class ["os-connection-box"] ]
    [ sign_in
    ; sign_up
    ]

let%shared user_box
    ?(a_placeholder_email="Your email")
    ?(a_placeholder_pwd="Your password")
    ?(text_keep_me_logged_in="keep me logged in")
    ?(content_popup_forgotpwd="Recover password")
    ?(text_button_forgotpwd="Forgot your password?")
    ?(text_sign_in="Sign in")
    ?(text_sign_up="Sign up")
    ?(text_send_button="Send")
    ?user
    () =
  match user with
  | None ->
    connection_box
      ~a_placeholder_email
      ~a_placeholder_pwd
      ~text_keep_me_logged_in
      ~content_popup_forgotpwd
      ~text_button_forgotpwd
      ~text_sign_in
      ~text_sign_up
      ~text_send_button
      ()
  | Some user -> Lwt.return (connected_user_box ~user)
