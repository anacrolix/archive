#!/usr/bin/env python

import gtk
import pdb
import random

def button_set_stock_image(button, stock_id):
    image = gtk.Image()
    image.set_from_stock(stock_id, gtk.ICON_SIZE_BUTTON)
    button.set_image(image)

class EncounterWindow:
    def drag_to_status(self, widget, drag_context, x, y, selection_data, info, timestamp):
        if selection_data.target == "condition":
            path, droppos = widget.get_dest_row_at_pos(x, y)
            print droppos
            model = widget.get_model()
            droprow = model[path]
            cmbtrow = droprow.parent or droprow
            assert not cmbtrow.parent
            if droprow.parent:
                if droppos in (
                        gtk.TREE_VIEW_DROP_INTO_OR_BEFORE,
                        gtk.TREE_VIEW_DROP_BEFORE):
                    insert_func = lambda data: model.insert_before(cmbtrow.iter, droprow.iter, data)
                elif droppos in (
                        gtk.TREE_VIEW_DROP_INTO_OR_AFTER,
                        gtk.TREE_VIEW_DROP_AFTER):
                    insert_func = lambda data: model.insert_after(cmbtrow.iter, droprow.iter, data)
                else: assert False
            else:
                if droppos in (
                        gtk.TREE_VIEW_DROP_INTO_OR_BEFORE,
                        gtk.TREE_VIEW_DROP_INTO_OR_AFTER):
                    insert_func = lambda data: model.append(cmbtrow.iter, data)
                else: return
            for a in eval(selection_data.data):
                for b in cmbtrow.iterchildren():
                    if model.get_value(b.iter, 1) == a:
                        break
                else:
                    insert_func((None, a))
            else:
                widget.expand_to_path(cmbtrow.path)
        else:
            assert False

    def drag_from_conditions(self, widget, drag_context, selection_data, info, timestamp):
        #print selection_data.get_targets()
        if selection_data.target == "condition":
            model, paths = widget.get_selection().get_selected_rows()
            print model, paths
            data = [model[p][0] for p in paths]
            print data
            selection_data.set(selection_data.target, 8, repr(data))
        else:
            assert False

    def next_turn(self, button):
        self.statstore.move_before(self.statstore.get_iter_first(), None)

    def setup_gui(self):
        window = gtk.Window()
        statstore = gtk.TreeStore(object, str)
        statview = gtk.TreeView(statstore)
        condstore = gtk.ListStore(str)
        condview = gtk.TreeView(condstore)
        nextturn = gtk.Button("NEXT!!!")

        a = gtk.Table(rows=2, columns=2)
        a.set_col_spacing(0, 5)
        window.add(a)
        #b.set_spacing(5)
        a.attach(statview, 0, 1, 0, 1)
        a.attach(condview, 1, 2, 0, 1, xoptions=0)
        b = gtk.HButtonBox()
        b.add(nextturn)
        a.attach(b, 0, 1, 1, 2, yoptions=0)

        window.set_title("Encounter")
        window.show_all()
        cellr = gtk.CellRendererText()
        tvcol = gtk.TreeViewColumn("Init", cellr)
        def initcell_cdf(column, cell, model, iter):
            a = model.get_value(iter, 0)
            cell.set_property("text", str(a) if isinstance(a, int) else "")
        tvcol.set_cell_data_func(cellr, initcell_cdf)
        statview.append_column(tvcol)
        tvcol = gtk.TreeViewColumn("Combatant", gtk.CellRendererText(), text=1)
        statview.append_column(tvcol)
        statview.set_expander_column(tvcol)
        statview.enable_model_drag_dest([("condition", 0, 0)], gtk.gdk.ACTION_COPY)
        statview.connect("drag-data-received", self.drag_to_status)
        condview.append_column(gtk.TreeViewColumn("Condition", gtk.CellRendererText(), text=0))
        condview.enable_model_drag_source(gtk.gdk.BUTTON1_MASK, [("condition", 0, 0)], gtk.gdk.ACTION_COPY)
        #condview.get_selection().set_mode(gtk.SELECTION_MULTIPLE)
        condview.connect("drag-data-get", self.drag_from_conditions)
        nextturn.connect("clicked", self.next_turn)
        button_set_stock_image(nextturn, gtk.STOCK_JUMP_TO)

        self.statstore = statstore
        self.condstore = condstore

    def __init__(self, combatants):
        self.setup_gui()
        for a in ["Immobilized", "Stunned", "Poisoned", "Marked"]:
            self.condstore.append((a,))
        ssitems = []
        for a, b in combatants:
            ssitems.append((random.randint(1, 20) + b, a))
        for a in sorted(ssitems, reverse=True):
            self.statstore.append(None, a)

class AddCombatantDialog:
    def __init__(self, parent):
        dialog = gtk.Dialog("Add Combatant", parent,
                buttons=(gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                    gtk.STOCK_OK, gtk.RESPONSE_OK))
        name = gtk.Entry()
        init = gtk.SpinButton()
        hbox = gtk.HBox()

        hbox.add(name)
        hbox.add(init)
        dialog.vbox.add(hbox)

        init.set_range(-5, 50)
        init.set_increments(1, 5)
        hbox.show_all()

        self.dialog = dialog
        self.name_entry = name
        self.init_entry = init

    def run(self):
        response = self.dialog.run()
        self.dialog.hide()
        return response

    def get_name(self):
        return self.name_entry.get_text()

    def get_initiative(self):
        return self.init_entry.get_value_as_int()

class MainWindow:
    def add_combatant(self, button):
        a = AddCombatantDialog(self.window)
        if a.run() == gtk.RESPONSE_OK:
            assert not a.get_name().lower() in map(str.lower, self.combatants)
            self.combatants[a.get_name()] = a.get_initiative()
            self.update_model()

    def new_encounter(self, button):
        EncounterWindow([self.cmbtmodl.get(tmri.iter, 0, 1) for tmri in self.cmbtmodl])

    def change_initiative(self, button, change):
        model, paths = self.initview.get_selection().get_selected_rows()
        for p in paths:
            iter = model[p].iter
            model.set_value(iter, 1, model.get_value(iter, 1) + change)

    def setup_gui(self):
        window = gtk.Window()
        cmbtmodl = gtk.ListStore(str, int)
        initview = gtk.TreeView(cmbtmodl)
        addcmbt = gtk.Button(stock=gtk.STOCK_ADD)
        startenc = gtk.Button("Start New Encounter")
        incinit = gtk.Button("+1 Init")
        decinit = gtk.Button("-1 Init")
        vbox1 = gtk.VBox()
        hbox1 = gtk.HBox()
        vbbox1 = gtk.VButtonBox()
        hbbox1 = gtk.HButtonBox()

        window.add(vbox1)
        vbox1.pack_start(hbox1)
        hbox1.pack_start(initview)
        hbox1.pack_start(vbbox1, expand=False)
        vbbox1.set_layout(gtk.BUTTONBOX_START)
        vbbox1.add(addcmbt)
        vbbox1.add(incinit)
        vbbox1.set_child_secondary(incinit, True)
        vbbox1.add(decinit)
        vbbox1.set_child_secondary(decinit, True)
        vbox1.pack_start(hbbox1, expand=False)
        hbbox1.add(startenc)

        window.connect('destroy', lambda w: gtk.main_quit())
        window.set_title("Initiator")
        window.show_all()
        cmbtmodl.set_sort_column_id(1, gtk.SORT_DESCENDING)
        initview.append_column(gtk.TreeViewColumn("Name", gtk.CellRendererText(), text=0))
        def initcell_cdf(column, cell, model, iter):
            cell.set_property("text", "%+d" % (model.get(iter, 1)[0],))
        initcell = gtk.CellRendererText()
        initcol = gtk.TreeViewColumn("Init", initcell)
        initcol.set_cell_data_func(initcell, initcell_cdf)
        initview.append_column(initcol)
        for a, b in enumerate((True, False)):
            initview.get_column(a).set_expand(b)
        initview.get_selection().set_mode(gtk.SELECTION_MULTIPLE)
        addcmbt.connect('clicked', self.add_combatant)
        incinit.connect('clicked', self.change_initiative, 1)
        button_set_stock_image(incinit, gtk.STOCK_GO_UP)
        decinit.connect('clicked', self.change_initiative, -1)
        button_set_stock_image(decinit, gtk.STOCK_GO_DOWN)
        startenc.connect("clicked", self.new_encounter)

        self.window = window
        self.cmbtmodl = cmbtmodl
        self.initview = initview

    def __init__(self):
        self.setup_gui()
        for a in [("Marek", 3), ("Mael", 3), ("Partin", 8), ("Vessler", 4), ("Vimak", 6)]:
            self.cmbtmodl.append(a)

if __name__ == "__main__":
    MainWindow()
    gtk.main()
