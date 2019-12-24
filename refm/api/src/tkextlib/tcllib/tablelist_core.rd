
= class Tk::Tcllib::Tablelist < TkWindow
include Tk::Tcllib::TablelistItemConfig
#@# TODO: #7000 が解決したら適切に分岐を行う。
include Tk::Scrollable

== Class Methods
--- package_name
#@todo

--- package_version
#@todo

--- use_Tile?
#@todo

--- getTablelistPath(descendant)
#@todo

--- convEventFields(descendant, x, y)
#@todo

--- addBWidgetEntry(name = None)
#@todo

--- addBWidgetSpinBox(name = None)
#@todo

--- addBWidgetComboBox(name = None)
#@todo

--- addIncrEntryfield(name = None)
#@todo

--- addIncrDateTimeWidget(type, seconds = false, name = None)
#@todo

--- addIncrSpinner(name = None)
#@todo

--- addIncrSpinint(name = None)
#@todo

--- addIncrCombobox(name = None)
#@todo

--- addOakleyCombobox(name = None)
#@todo

--- addDateMentry(format, separator, gmt = false, name = None)
#@todo

--- addTimeMentry(format, separator, gmt = false, name = None)
#@todo

--- addFixedPointMentry(count1, count2, comma = false, name = None)
#@todo

--- addIPAddrMentry(name = None)
#@todo

== Instance Methods
--- activate(index)
#@todo

--- activate_cell(index)
--- activatecell(index)
#@todo

--- get_attrib(name = nil)
#@todo

--- set_attrib(*args)
#@todo

--- bbox(index)
#@todo

--- bodypath
#@todo

--- bodytag
#@todo

--- cancel_editing 
--- cancelediting
#@todo

--- cellindex(idx)
#@todo

--- cellselection_anchor(idx)
#@todo

--- cellselection_clear(first, last = nil)
#@todo

--- cellselection_includes(idx)
#@todo

--- cellselection_set(first, last = nil)
#@todo

--- columncount
#@todo

--- columnindex(idx)
#@todo

--- containing(y)
#@todo

--- containing_cell(x, y)
--- containingcell(x, y)
#@todo

--- containing_column(x)
--- containingcolumn(x)
#@todo

--- curcellselection
#@todo

--- curselection
#@todo

--- delete_items(first, last = nil)
--- delete(first, last = nil)
--- deleteitems(first, last = nil)
#@todo

--- delete_columns(first, last = nil)
--- deletecolumns(first, last = nil)
#@todo

--- edit_cell(idx)
--- editcell(idx)
#@todo

--- editwinpath
#@todo

--- entrypath
#@todo

--- fill_column(idx, txt)
--- fillcolumn(idx, txt)
#@todo

--- finish_editing
--- finishediting
#@todo

--- get(first, last = nil)
#@todo

--- get_cells(first, last = nil)
--- getcells(first, last = nil)
#@todo

--- get_columns(first, last = nil)
--- getcolumns(first, last = nil)
#@todo

--- get_keys(first, last = nil)
--- getkeys(first, last = nil)
#@todo

--- imagelabelpath(idx)
#@todo

--- index(idx)
#@todo

--- insert(idx, *items)
#@todo

--- insert_columnlist(idx, columnlist)
--- insertcolumnlist(idx, columnlist)
#@todo

--- insert_columns(idx, *args)
--- insertcolumns(idx, *args)
#@todo

--- insert_list(idx, list)
--- insertlist(idx, list)
#@todo

--- itemlistvar
#@todo

--- labelpath(idx)
#@todo

--- labels
#@todo

--- move(src, target)
#@todo

--- move_column(src, target)
--- movecolumn(src, target)
#@todo

--- nearest(y)
#@todo

--- nearest_cell(x, y)
--- nearestcell(x, y)
#@todo

--- nearest_column(x)
--- nearestcolumn(x)
#@todo

--- reject_input
--- rejectinput
#@todo

--- reset_sortinfo
--- resetsortinfo
#@todo

--- scan_mark(x, y)
#@todo

--- scan_dragto(x, y)
#@todo

--- see(idx)
#@todo

--- see_cell(idx)
--- seecell(idx)
#@todo

--- see_column(idx)
--- seecolumn(idx)
#@todo

--- selection_anchor(idx)
#@todo

--- selection_clear(first, last = nil)
#@todo

--- selection_includes(idx)
#@todo

--- selection_set(first, last = nil)
#@todo

--- separatorpath(idx = nil)
#@todo

--- separators
#@todo

--- size
#@todo

--- sort(order = nil)
#@todo

--- sort_increasing
#@todo

--- sort_decreasing
#@todo

--- sort_by_column(idx, order = nil)
#@todo

--- sort_by_column_increasing(idx)
#@todo

--- sort_by_column_decreasing(idx)
#@todo

--- sortcolumn
#@todo

--- sortorder
#@todo

--- toggle_visibility(first, last = nil)
--- togglevisibility(first, last = nil)
#@todo

--- windowpath(idx)
#@todo

= class Tk::Tcllib::TableList
alias Tk::Tcllib::Tablelist

#@include(TablelistItemConfig)

