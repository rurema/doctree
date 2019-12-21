
require tk
require tk/canvas
require tkextlib/iwidgets

= class Tk::Iwidgets::Scrolledcanvas < Tk::Iwidgets::Scrolledwidget

include TkCanvasItemConfig

== Class Methods

--- new(*args)
#@todo



== Instance Methods

--- addtag(tag, mode, *args)
#@todo



--- addtag_above(tagOrId, target)
#@todo



--- addtag_all(tagOrId)
#@todo



--- addtag_below(tagOrId, target)
#@todo



--- addtag_closest(tagOrId, x, y, halo = None, start = None)
#@todo



--- addtag_enclosed(tagOrId, x1, y1, x2, y2)
#@todo



--- addtag_overlapping(tagOrId, x1, y1, x2, y2)
#@todo



--- addtag_withtag(tagOrId, tag)
#@todo



--- bbox(tagOrId, *tags)
#@todo



--- canvasx(screen_x, *args)
#@todo



--- canvasy(screen_y, *args)
#@todo



--- child_site
#@todo



--- coords(tag, *args)
#@todo



--- create(type, *args)
#@todo

create a canvas item without creating a TkcItem object

--- dchars(tag, first, last = None)
#@todo



--- delete(*args)
#@todo
alias remove



--- dtag(tag, tag_to_del = None)
#@todo



--- find(mode, *args)
#@todo



--- find_above(target)
#@todo



--- find_all
#@todo



--- find_below(target)
#@todo



--- find_closest(x, y, halo = None, start = None)
#@todo



--- find_enclosed(x1, y1, x2, y2)
#@todo



--- find_overlapping(x1, y1, x2, y2)
#@todo



--- find_withtag(tag)
#@todo



--- gettags(tagOrId)
#@todo



--- icursor(tagOrId, index)
#@todo



--- index(tagOrId, idx)
#@todo



--- insert(tagOrId, index, string)
#@todo



--- itembind(tag, context, *args)
#@todo

def itembind(tag, context, cmd=Proc.new, *args)

  _bind([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- itembind_append(tag, context, *args)
#@todo

def itembind_append(tag, context, cmd=Proc.new, *args)

  _bind_append([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- itembind_remove(tag, context)
#@todo



--- itembindinfo(tag, context = nil)
#@todo



--- itemfocus(tagOrId = nil)
#@todo



--- itemtype(tag)
#@todo



--- justify(dir)
#@todo



--- lower(tag, below = nil)
#@todo



--- method_missing(id, *args)
#@todo



--- move(tag, x, y)
#@todo



--- postscript(keys)
#@todo



--- raise(tag, above = nil)
#@todo



--- remove(*args)
#@todo

Alias for #delete

--- scale(tag, x, y, xs, ys)
#@todo



--- scan_dragto(x, y)
#@todo



--- scan_mark(x, y)
#@todo



--- select(mode, *args)
#@todo



--- select_adjust(tagOrId, index)
#@todo



--- select_clear
#@todo



--- select_from(tagOrId, index)
#@todo



--- select_item
#@todo



--- select_to(tagOrId, index)
#@todo



--- xview(*index)
#@todo



--- xview_moveto(*index)
#@todo



--- xview_scroll(*index)
#@todo



--- yview(*index)
#@todo



--- yview_moveto(*index)
#@todo



--- yview_scroll(*index)
#@todo




