#@since 1.8.2

require tk
require tk/canvas
require tkextlib/iwidgets

= class Tk::Iwidgets::Scrolledcanvas < Tk::Iwidgets::Scrolledwidget

include TkCanvasItemConfig

== Class Methods

--- new(*args)



== Instance Methods

--- addtag(tag, mode, *args)



--- addtag_above(tagOrId, target)



--- addtag_all(tagOrId)



--- addtag_below(tagOrId, target)



--- addtag_closest(tagOrId, x, y, halo = None, start = None)



--- addtag_enclosed(tagOrId, x1, y1, x2, y2)



--- addtag_overlapping(tagOrId, x1, y1, x2, y2)



--- addtag_withtag(tagOrId, tag)



--- bbox(tagOrId, *tags)



--- canvasx(screen_x, *args)



--- canvasy(screen_y, *args)



--- child_site



--- coords(tag, *args)



--- create(type, *args)

create a canvas item without creating a TkcItem object

--- dchars(tag, first, last = None)



--- delete(*args)
alias remove



--- dtag(tag, tag_to_del = None)



--- find(mode, *args)



--- find_above(target)



--- find_all



--- find_below(target)



--- find_closest(x, y, halo = None, start = None)



--- find_enclosed(x1, y1, x2, y2)



--- find_overlapping(x1, y1, x2, y2)



--- find_withtag(tag)



--- gettags(tagOrId)



--- icursor(tagOrId, index)



--- index(tagOrId, idx)



--- insert(tagOrId, index, string)



--- itembind(tag, context, *args)

def itembind(tag, context, cmd=Proc.new, *args)

  _bind([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- itembind_append(tag, context, *args)

def itembind_append(tag, context, cmd=Proc.new, *args)

  _bind_append([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- itembind_remove(tag, context)



--- itembindinfo(tag, context = nil)



--- itemfocus(tagOrId = nil)



--- itemtype(tag)



--- justify(dir)



--- lower(tag, below = nil)



--- method_missing(id, *args)



--- move(tag, x, y)



--- postscript(keys)



--- raise(tag, above = nil)



--- remove(*args)

Alias for #delete

--- scale(tag, x, y, xs, ys)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- select(mode, *args)



--- select_adjust(tagOrId, index)



--- select_clear



--- select_from(tagOrId, index)



--- select_item



--- select_to(tagOrId, index)



--- xview(*index)



--- xview_moveto(*index)



--- xview_scroll(*index)



--- yview(*index)



--- yview_moveto(*index)



--- yview_scroll(*index)




#@end
