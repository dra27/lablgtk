(* $Id$ *)

open Gdk
open Gtk
open GtkObj
open GdkObj

(* let id = Thread.create GtkThread.main () *)
let window = new_window `TOPLEVEL

let w = window#show (); window#misc#window
let drawing = new drawing w

let _ =
  window#connect_destroy callback:Main.quit;
  window#connect_event#expose callback:
    begin fun _ ->
      drawing#polygon filled:true
	[ 10,100; 35,35; 100,10; 165,35; 190,100;
	  165,165; 100,190; 35,165; 10,100 ];
      false
    end;
  (* Thread.join id *)
  Main.main ()
