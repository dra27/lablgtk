(* $Id$ *)

open Gaux
open Gtk
open Tags
open GtkBase

module Window = struct
  let cast w : window obj = Object.try_cast w "GtkWindow"
  external create : window_type -> window obj = "ml_gtk_window_new"
  external set_title : [>`window] obj -> string -> unit
      = "ml_gtk_window_set_title"
  external set_wmclass : [>`window] obj -> name:string -> clas:string -> unit
      = "ml_gtk_window_set_wmclass"
  external get_wmclass_name : [>`window] obj -> string
      = "ml_gtk_window_get_wmclass_name"
  external get_wmclass_class : [>`window] obj -> string
      = "ml_gtk_window_get_wmclass_class"
  external add_accel_group : [>`window] obj -> accel_group -> unit
      = "ml_gtk_window_add_accel_group"
  external remove_accel_group :
      [>`window] obj -> accel_group -> unit
      = "ml_gtk_window_remove_accel_group"
  external activate_focus : [>`window] obj -> bool
      = "ml_gtk_window_activate_focus"
  external activate_default : [>`window] obj -> bool
      = "ml_gtk_window_activate_default"
  external set_geometry_hints :
      [>`window] obj -> ?pos: bool -> ?min_size: int * int ->
      ?max_size: int * int -> ?base_size: int * int ->
      ?aspect: float * float -> ?resize_inc: int * int ->
      ?win_gravity: Gdk.Tags.gravity -> ?user_pos: bool ->
      ?user_size: bool -> [>`widget] obj -> unit
      = "ml_gtk_window_set_geometry_hints_bc"
        "ml_gtk_window_set_geometry_hints"
  external set_gravity : [>`window] obj -> Gdk.Tags.gravity -> unit
      = "ml_gtk_window_set_gravity"
  external get_gravity : [>`window] obj -> Gdk.Tags.gravity
      = "ml_gtk_window_get_gravity"
  external set_transient_for : [>`window] obj ->[>`window] obj -> unit
      = "ml_gtk_window_set_transient_for"
  external get_transient_for : [>`window] obj -> window obj
      = "ml_gtk_window_get_transient_for"
  external list_toplevels : unit -> window obj list
      = "ml_gtk_window_list_toplevels"
  external add_mnemonic :
      [>`window] obj -> Gdk.keysym -> [>`widget] obj -> unit
      = "ml_gtk_window_add_mnemonic"
  external remove_mnemonic :
      [>`window] obj -> Gdk.keysym -> [>`widget] obj -> unit
      = "ml_gtk_window_remove_mnemonic"
  external activate_mnemonic :
      [>`window] obj -> ?modi: Gdk.Tags.modifier list -> Gdk.keysym -> unit
      = "ml_gtk_window_mnemonic_activate"
  external get_focus : [>`window] obj -> widget obj
      = "ml_gtk_window_get_focus"
  (* set_focus/default are called by Widget.grab_focus/default *)
  external set_focus : [>`window] obj -> [>`widget] obj -> unit
      = "ml_gtk_window_set_focus"
  external set_default : [>`window] obj -> [>`widget] obj -> unit
      = "ml_gtk_window_set_default"
  external present :  [>`window] obj -> unit = "ml_gtk_window_present"
  external iconify :  [>`window] obj -> unit = "ml_gtk_window_iconify"
  external deiconify :  [>`window] obj -> unit = "ml_gtk_window_deiconify"
  external stick :  [>`window] obj -> unit = "ml_gtk_window_stick"
  external unstick :  [>`window] obj -> unit = "ml_gtk_window_unstick"
  external maximize :  [>`window] obj -> unit = "ml_gtk_window_maximize"
  external unmaximize :  [>`window] obj -> unit = "ml_gtk_window_unmaximize"
  external fullscreen :  [>`window] obj -> unit = "ml_gtk_window_fullscreen"
  external unfullscreen :  [>`window] obj -> unit
      = "ml_gtk_window_unfullscreen"
  external set_decorated : [>`window] obj -> bool -> unit
      = "ml_gtk_window_set_decorated"
  external set_mnemonic_modifier :
      [>`window] obj -> Gdk.Tags.modifier list -> unit
      = "ml_gtk_window_set_mnemonic_modifier"
  external resize :
      [>`window] obj -> width:int -> height:int -> unit
      = "ml_gtk_window_resize"
  external set_role : [>`window] obj -> string -> unit
      = "ml_gtk_window_set_role"
  external get_role : [>`window] obj -> string
      = "ml_gtk_window_get_role"

  module Prop = GtkProps.PWindow

  let set_wmclass ?name ?clas:wm_class w =
    set_wmclass w ~name:(may_default get_wmclass_name w ~opt:name)
      ~clas:(may_default get_wmclass_class w ~opt:wm_class)

  let setter ~cont ?title ?wm_name ?wm_class ?icon ?screen ?position
      ?allow_grow ?allow_shrink ?resizable ?modal ?(x = -2) ?(y = -2) =
    cont (fun w ->
      may title ~f:(set_title w);
      let may_set p = may ~f:(Gobject.Property.set w p) in
      if wm_name <> None || wm_class <> None then
        set_wmclass w ?name:wm_name ?clas:wm_class;
      if icon <> None then Gobject.Property.set w Prop.icon icon;
      may_set Prop.screen screen;
      may_set Prop.window_position position;
      may_set Prop.allow_grow allow_grow;
      may_set Prop.allow_shrink allow_shrink;
      may_set Prop.resizable resizable;
      may_set Prop.modal modal;
      if x <> -2 || y <> -2 then Widget.set_uposition w ~x ~y)

  let set ?title = setter ~cont:(fun f w -> f w) ?title

  module Signals = struct
    open GtkSignal
    let activate_default =
      { name = "activate_default"; classe = `window; marshaller =marshal_unit }
    let activate_focus =
      { name = "activate_focus"; classe = `window; marshaller = marshal_unit }
    let keys_changed =
      { name = "keys_changed"; classe = `window; marshaller = marshal_unit }
    let move_focus =
      let marshal f argv = function
        | `INT dir :: _ ->
            f (Gpointer.decode_variant GtkEnums.direction_type dir)
        | _ -> invalid_arg "GtkWindow.Window.Signals.marshal_focus"
      in { name = "move_focus"; classe = `window; marshaller = marshal }
    let set_focus =
      { name = "set_focus"; classe = `window;
        marshaller = Widget.Signals.marshal_opt }
  end
end

module Dialog = struct
  let cast w : dialog obj = Object.try_cast w "GtkDialog"
  external create : unit -> dialog obj = "ml_gtk_dialog_new"
  external action_area : [>`dialog] obj -> box obj
      = "ml_GtkDialog_action_area"
  external vbox : [>`dialog] obj -> box obj
      = "ml_GtkDialog_vbox"
  external add_button : [>`dialog] obj -> string -> int -> unit 
      = "ml_gtk_dialog_add_button"
  external response : [>`dialog] obj -> int -> unit
      = "ml_gtk_dialog_response"
  external set_response_sensitive : [>`dialog] obj -> int -> bool -> unit
      = "ml_gtk_dialog_set_response_sensitive"
  external set_default_response : [>`dialog] obj -> int -> unit
      = "ml_gtk_dialog_set_default_response"
  external run : [>`dialog] obj -> int
      = "ml_gtk_dialog_run"
  let std_response = Gpointer.encode_variant GtkEnums.response
  external create_message :
      ?parent:[>`window] obj -> message_type:Gtk.Tags.message_type ->
      buttons:Gtk.Tags.buttons -> message:string -> unit -> dialog obj
      = "ml_gtk_message_dialog_new"
  module Signals = struct
    open GtkSignal
    let response =
      { name = "response"; classe = `dialog; marshaller = marshal_int }
    let close =
      { name = "close"; classe = `dialog; marshaller = marshal_unit }
  end
  module Prop = struct
    open Gobject
    let has_separator = 
      { name = "has_separator" ; classe = `dialog ; conv = Data.boolean }
  end
end

module InputDialog = struct
  let cast w : input_dialog obj = Object.try_cast w "GtkInputDialog"
  external create : unit -> input_dialog obj = "ml_gtk_input_dialog_new"
  module Signals = struct
    open GtkSignal
    let enable_device =
      { name = "enable_device"; classe = `inputdialog;
        marshaller = marshal_int }
    let disable_device =
      { name = "disable_device"; classe = `inputdialog;
        marshaller = marshal_int }
  end
end

module FileSelection = struct
  let cast w : file_selection obj = Object.try_cast w "GtkFileSelection"
  external create : string -> file_selection obj = "ml_gtk_file_selection_new"
  external set_filename : [>`filesel] obj -> string -> unit
      = "ml_gtk_file_selection_set_filename"
  external get_filename : [>`filesel] obj -> string
      = "ml_gtk_file_selection_get_filename"
  external complete : [>`filesel] obj -> filter:string -> unit
      = "ml_gtk_file_selection_complete"
  external show_fileop_buttons : [>`filesel] obj -> unit
      = "ml_gtk_file_selection_show_fileop_buttons"
  external hide_fileop_buttons : [>`filesel] obj -> unit
      = "ml_gtk_file_selection_hide_fileop_buttons"
  external get_ok_button : [>`filesel] obj -> button obj
      = "ml_gtk_file_selection_get_ok_button"
  external get_cancel_button : [>`filesel] obj -> button obj
      = "ml_gtk_file_selection_get_cancel_button"
  external get_help_button : [>`filesel] obj -> button obj
      = "ml_gtk_file_selection_get_help_button"
  external get_file_list : [>`filesel] obj -> clist obj
      = "ml_gtk_file_selection_get_file_list"
  external set_select_multiple : [>`filesel] obj -> bool -> unit
      = "ml_gtk_file_selection_set_select_multiple"
  external get_select_multiple : [>`filesel] obj -> bool
      = "ml_gtk_file_selection_get_select_multiple"
  external get_selections : [>`filesel] obj -> string list
      = "ml_gtk_file_selection_get_selections"
  let set_fileop_buttons w = function
      true -> show_fileop_buttons w
    | false -> hide_fileop_buttons w
  let set ?filename ?fileop_buttons ?select_multiple w =
    may filename ~f:(set_filename w);
    may fileop_buttons ~f:(set_fileop_buttons w);
    may select_multiple ~f:(set_select_multiple w)
end

module FontSelectionDialog = struct
  let cast w : font_selection_dialog obj =
    Object.try_cast w "GtkFontSelectionDialog"
  external create : ?title:string -> unit -> font_selection_dialog obj
      = "ml_gtk_font_selection_dialog_new"
  external font_selection : [>`fontseldialog] obj -> font_selection obj
      = "ml_gtk_font_selection_dialog_fontsel"
  external ok_button : [>`fontseldialog] obj -> button obj
      = "ml_gtk_font_selection_dialog_ok_button"
  external apply_button : [>`fontseldialog] obj -> button obj
      = "ml_gtk_font_selection_dialog_apply_button"
  external cancel_button : [>`fontseldialog] obj -> button obj
      = "ml_gtk_font_selection_dialog_cancel_button"
end

module Plug = struct
  let cast w : plug obj = Object.try_cast w "GtkPlug"
  external create : Gdk.xid -> plug obj = "ml_gtk_plug_new"
end
