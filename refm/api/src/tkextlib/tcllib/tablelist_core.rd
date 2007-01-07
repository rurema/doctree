#@since 1.8.4

= class Tk::Tcllib::Tablelist < TkWindow
include Tk::Tcllib::TablelistItemConfig
include Scrollable

== Class Methods
--- package_name

--- package_version

--- use_Tile?

--- getTablelistPath(descendant)

--- convEventFields(descendant, x, y)

--- addBWidgetEntry(name = None)

--- addBWidgetSpinBox(name = None)

--- addBWidgetComboBox(name = None)

--- addIncrEntryfield(name = None)

--- addIncrDateTimeWidget(type, seconds = false, name = None)

--- addIncrSpinner(name = None)

--- addIncrSpinint(name = None)

--- addIncrCombobox(name = None)

--- addOakleyCombobox(name = None)

--- addDateMentry(format, separator, gmt = false, name = None)

--- addTimeMentry(format, separator, gmt = false, name = None)

--- addFixedPointMentry(count1, count2, comma = false, name = None)

--- addIPAddrMentry(name = None)

== Instance Methods
--- activate(index)

--- activate_cell(index)
--- activatecell(index)

--- get_attrib(name = nil)

--- set_attrib(*args)

--- bbox(index)

--- bodypath

--- bodytag

--- cancel_editing 
--- cancelediting

--- cellindex(idx)

--- cellselection_anchor(idx)

--- cellselection_clear(first, last = nil)

--- cellselection_includes(idx)

--- cellselection_set(first, last = nil)

--- columncount

--- columnindex(idx)

--- containing(y)

--- containing_cell(x, y)
--- containingcell(x, y)

--- containing_column(x)
--- containingcolumn(x)

--- curcellselection

--- curselection

--- delete_items(first, last = nil)
--- delete(first, last = nil)
--- deleteitems(first, last = nil)

--- delete_columns(first, last = nil)
--- deletecolumns(first, last = nil)

--- edit_cell(idx)
--- editcell(idx)

--- editwinpath

--- entrypath

--- fill_column(idx, txt)
--- fillcolumn(idx, txt)

--- finish_editing
--- finishediting

--- get(first, last = nil)

--- get_cells(first, last = nil)
--- getcells(first, last = nil)

--- get_columns(first, last = nil)
--- getcolumns(first, last = nil)

--- get_keys(first, last = nil)
--- getkeys(first, last = nil)

--- imagelabelpath(idx)

--- index(idx)

--- insert(idx, *items)

--- insert_columnlist(idx, columnlist)
--- insertcolumnlist(idx, columnlist)

--- insert_columns(idx, *args)
--- insertcolumns(idx, *args)

--- insert_list(idx, list)
--- insertlist(idx, list)

--- itemlistvar

--- labelpath(idx)

--- labels

--- move(src, target)

--- move_column(src, target)
--- movecolumn(src, target)

--- nearest(y)

--- nearest_cell(x, y)
--- nearestcell(x, y)

--- nearest_column(x)
--- nearestcolumn(x)

--- reject_input
--- rejectinput

--- reset_sortinfo
--- resetsortinfo

--- scan_mark(x, y)

--- scan_dragto(x, y)

--- see(idx)

--- see_cell(idx)
--- seecell(idx)

--- see_column(idx)
--- seecolumn(idx)

--- selection_anchor(idx)

--- selection_clear(first, last = nil)

--- selection_includes(idx)

--- selection_set(first, last = nil)

--- separatorpath(idx = nil)

--- separators

--- size

--- sort(order = nil)

--- sort_increasing

--- sort_decreasing

--- sort_by_column(idx, order = nil)

--- sort_by_column_increasing(idx)

--- sort_by_column_decreasing(idx)

--- sortcolumn

--- sortorder

--- toggle_visibility(first, last = nil)
--- togglevisibility(first, last = nil)

--- windowpath(idx)

= class Tk::Tcllib::TableList
alias Tk::Tcllib::Tablelist

#@include(TablelistItemConfig)

#@end
