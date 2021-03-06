open Gtk

let destroy () = GMain.Main.quit ()

let main () =
 ignore (GMain.init ());
 let main_window = GWindow.window () in
 let accel_group = GtkData.AccelGroup.create () in
 main_window#add_accel_group accel_group;
 let quit_button = GButton.button ~label:"Quit" ~packing:main_window#add () in
 quit_button#misc#add_accelerator
   ~sgn:GtkButtonProps.Button.S.activate
   ~group:accel_group
   ~modi:[`CONTROL] GdkKeysyms._q;
 ignore (quit_button#connect#clicked ~callback:destroy);
 main_window#show ();
 GMain.main ()

let () = main ()
