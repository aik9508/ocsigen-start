[%%server.start]

val main_service :
  (
    unit,
    unit,
    Eliom_service.get,
    Eliom_service.att,
    Eliom_service.non_co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val preregister_service' :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val forgot_password_service :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val set_personal_data_service' :
  (
    unit,
    (string * string) * (string * string),
    Eliom_service.post,
    Eliom_service.non_att, Eliom_service.co, Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name) *
      ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name),
    Eliom_service.non_ocaml
  ) Eliom_service.t

val sign_up_service' :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val connect_service :
  (
    unit,
    (string * string) * bool,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ], unit,
    ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name) *
      [ `One of bool ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val disconnect_service :
  (
    unit,
    unit,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val activation_service :
  (
    string,
    unit,
    Eliom_service.get,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    [ `One of string ] Eliom_parameter.param_name,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val set_password_service' :
  (
    unit,
    string * string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val add_email_service :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

[%%client.start]

val main_service :
  (
    unit,
    unit,
    Eliom_service.get,
    Eliom_service.att,
    Eliom_service.non_co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val preregister_service' :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val forgot_password_service :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val set_personal_data_service' :
  (
    unit,
    (string * string) * (string * string),
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name) *
      ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name),
    Eliom_service.non_ocaml
  ) Eliom_service.t

val sign_up_service' :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val connect_service :
  (
    unit,
    (string * string) * bool,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    ([ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name) *
      [ `One of bool ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val disconnect_service :
  (
    unit,
    unit,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val activation_service :
  (
    string,
    unit,
    Eliom_service.get,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    [ `One of string ] Eliom_parameter.param_name,
    unit,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val set_password_service' :
  (
    unit,
    string * string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name *
      [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t

val add_email_service :
  (
    unit,
    string,
    Eliom_service.post,
    Eliom_service.non_att,
    Eliom_service.co,
    Eliom_service.non_ext,
    Eliom_service.reg,
    [ `WithoutSuffix ],
    unit,
    [ `One of string ] Eliom_parameter.param_name,
    Eliom_service.non_ocaml
  ) Eliom_service.t
