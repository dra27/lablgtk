(* $Id$ *)

open Gaux
open Gobject
open Gtk
open GtkBase
open GtkMisc
open OGtkProps
open GObj

let separator dir ?packing ?show () =
  let w = Separator.create dir [] in
  pack_return (new widget_full w) ~packing ~show

class statusbar_context obj ctx = object (self)
  val obj : statusbar obj = obj
  val context : Gtk.statusbar_context = ctx
  method context = context
  method push text = Statusbar.push obj context ~text
  method pop () = Statusbar.pop obj context
  method remove = Statusbar.remove obj context
  method flash ?(delay=1000) text =
    let msg = self#push text in
    Glib.Timeout.add ~ms:delay ~callback:(fun () -> self#remove msg; false);
    ()
end

class statusbar obj = object
  inherit GContainer.container_full (obj : Gtk.statusbar obj)
  method new_context ~name =
    new statusbar_context obj (Statusbar.get_context_id obj name)
end

let statusbar =
  GContainer.pack_container [] ~create:
    (fun p -> new statusbar (Statusbar.create p))

class calendar_signals obj = object
  inherit widget_signals_impl obj
  inherit calendar_sigs
end

class calendar obj = object
  inherit widget (obj : Gtk.calendar obj)
  method event = new GObj.event_ops obj
  method connect = new calendar_signals obj
  method select_month = Calendar.select_month obj
  method select_day = Calendar.select_day obj
  method mark_day = Calendar.mark_day obj
  method unmark_day = Calendar.unmark_day obj
  method clear_marks = Calendar.clear_marks obj
  method display_options = Calendar.display_options obj
  method date = Calendar.get_date obj
  method freeze () = Calendar.freeze obj
  method thaw () = Calendar.thaw obj
end

let calendar ?options ?packing ?show () =
  let w = Calendar.create [] in
  may options ~f:(Calendar.display_options w);
  pack_return (new calendar w) ~packing ~show

class drawing_area obj = object
  inherit widget_full (obj : Gtk.drawing_area obj)
  method event = new GObj.event_ops obj
  method set_size = DrawingArea.size obj
end

let drawing_area ?(width=0) ?(height=0) ?packing ?show () =
  let w = DrawingArea.create [] in
  if width <> 0 || height <> 0 then DrawingArea.size w ~width ~height;
  pack_return (new drawing_area w) ~packing ~show

class misc obj = object
  inherit ['a] widget_impl obj
  inherit misc_props
end

class arrow obj = object
  inherit misc obj
  inherit arrow_props
end

let arrow =
  Arrow.make_params [] ~cont:(
  Misc.all_params ~cont:(fun p ?packing ?show () ->
    pack_return (new arrow (Arrow.create p)) ~packing ~show))

class image obj = object (self)
  inherit misc obj
  inherit image_props
  method pixmap = new GDraw.pixmap (get Image.P.pixmap obj) ?mask:self#mask
  method set_pixmap (p : GDraw.pixmap) =
    set Image.P.pixmap obj p#pixmap;
    self#set_mask p#mask
end

type image_type = 
  [ `EMPTY | `PIXMAP | `IMAGE | `PIXBUF | `STOCK | `ICON_SET | `ANIMATION ]

let image =
  Image.make_params [] ~cont:(
  Misc.all_params ~cont:(fun p ?packing ?show () ->
    pack_return (new image (Image.create p)) ~packing ~show))

let pixmap pm =
  let pl = [param Image.P.pixmap pm#pixmap; param Image.P.mask pm#mask] in
  Misc.all_params pl ~cont:(fun pl ?packing ?show () ->
    pack_return (new image (Image.create pl)) ~packing ~show)

class label_skel obj = object
  inherit misc obj
  inherit label_props
end

class label obj = object
  inherit label_skel (obj : Gtk.label obj)
  method connect = new widget_signals obj
end

let label =
  Label.make_params [] ~cont:(
  Misc.all_params ~cont:(fun p ?packing ?show () ->
    pack_return (new label (Label.create p)) ~packing ~show))

let label_cast w = new label (Label.cast w#as_widget)

class tips_query_signals obj = object
  inherit widget_signals_impl (obj : Gtk.tips_query obj)
  inherit tips_query_sigs
end

class tips_query obj = object
  inherit label_skel obj
  method start () = TipsQuery.start_query obj
  method stop () = TipsQuery.stop_query obj
  inherit tips_query_props
  method connect = new tips_query_signals obj
end

let tips_query ?caller =
  let caller = may_map (fun w -> w#as_widget) caller in
  TipsQuery.make_params [] ?caller ~cont:(
  Misc.all_params ~cont:(fun p ?packing ?show () ->
    pack_return (new tips_query (TipsQuery.create p)) ~packing ~show))

class color_selection obj = object
  inherit [Gtk.color_selection] GObj.widget_impl obj
  method connect = new GObj.widget_signals obj
  method set_border_width = set Container.P.border_width obj
  inherit color_selection_props
end

let color_selection =
  ColorSelection.make_params [] ~cont:(
  GContainer.pack_container ~create:
    (fun p -> new color_selection (ColorSelection.create p)))

class font_selection obj = object
  inherit [Gtk.font_selection] widget_impl obj
  inherit font_selection_props
  method event = new event_ops obj
  method connect = new GObj.widget_signals obj
  method set_border_width = set Container.P.border_width obj
end

let font_selection =
  FontSelection.make_params [] ~cont:(
  GContainer.pack_container ~create:
    (fun p -> new font_selection (FontSelection.create p)))
