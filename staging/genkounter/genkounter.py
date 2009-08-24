#!/usr/bin/env python

import gtk
import random

class EncounterWindow:

    def update_models(self):
        self.condstore.clear()
        for a in self.conditions:
            self.condstore.append((a,))
        self.statstore.clear()
        for a in self.order:
            b = self.statii[a]
            c = self.statstore.append(None, (a, b[0], None))
            for d in b[1]:
                self.statstore.append(c, (None, None, d))

    def drag_to_status(self, widget, drag_context, x, y, selection_data, info, timestamp):
        if selection_data.target == "condition":
            path, droppos = widget.get_dest_row_at_pos(x, y)
            #assert droppos in (
            #        gtk.TREE_VIEW_DROP_INTO_OR_BEFORE,
            #        gtk.TREE_VIEW_DROP_INTO_OR_AFTER)
            row = widget.get_model()[path]
            while row.parent:
                row = row.parent
            name = row[0]
            self.statii[name][1].update(eval(selection_data.data))
            print self.statii
            path = row.path
            self.update_models()
            del row
            widget.expand_row(path, False)
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
        self.order.append(self.order[0])
        del self.order[0]
        self.update_models()

    def setup_gui(self):
        window = gtk.Window()
        statstore = gtk.TreeStore(str, int, str)
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
        statview.append_column(gtk.TreeViewColumn("Combatant", gtk.CellRendererText(), text=0))
        statview.append_column(gtk.TreeViewColumn("Initiative", gtk.CellRendererText(), text=1))
        statview.append_column(gtk.TreeViewColumn("Conditions", gtk.CellRendererText(), text=2))
        statview.drag_dest_set(gtk.DEST_DEFAULT_ALL, [("condition", 0, 0)], gtk.gdk.ACTION_COPY)
        #statview.drag_dest_set(gtk.DEST_DEFAULT_ALL, [], gtk.gdk.ACTION_COPY)
        statview.connect("drag-data-received", self.drag_to_status)
        condview.append_column(gtk.TreeViewColumn("Condition", gtk.CellRendererText(), text=0))
        condview.drag_source_set(gtk.gdk.BUTTON1_MASK, [("condition", 0, 0)], gtk.gdk.ACTION_COPY)
        condview.get_selection().set_mode(gtk.SELECTION_MULTIPLE)
        condview.connect("drag-data-get", self.drag_from_conditions)
        nextturn.connect("clicked", self.next_turn)

        self.statstore = statstore
        self.condstore = condstore

    def __init__(self, combatants):
        self.setup_gui()
        self.statii = {}
        self.order = []
        self.conditions = set(["Immobilized", "Stunned", "Poisoned", "Marked"])
        for a, b in combatants.iteritems():
            self.statii[a] = (random.randint(1, 20) + b, set())
        self.order = map(lambda j: j[0], sorted(self.statii.iteritems(), key=lambda i: i[1][0], reverse=True))
        print self.order
        print self.statii
        self.update_models()

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
        EncounterWindow(self.combatants)

    def update_model(self):
        a = self.combatant_model
        a.clear()
        b = self.combatants
        for c, d in b.iteritems():
            a.append((c, d))
        print a.get_sort_column_id()

    def setup_gui(self):
        window = gtk.Window()
        cmbtmodl = gtk.ListStore(str, int)
        initview = gtk.TreeView(cmbtmodl)
        addcmbt = gtk.Button("Add Combatant", gtk.STOCK_ADD)
        startenc = gtk.Button("Start New Encounter")
        vbox1 = gtk.VBox()
        hbox1 = gtk.HBox()
        vbbox1 = gtk.VButtonBox()
        hbbox1 = gtk.HButtonBox()

        window.add(vbox1)
        vbox1.pack_start(hbox1)
        hbox1.pack_start(initview)
        hbox1.pack_start(vbbox1, expand=False)
        vbbox1.add(addcmbt)
        vbox1.pack_start(hbbox1, expand=False)
        hbbox1.add(startenc)

        window.connect('destroy', lambda w: gtk.main_quit())
        window.set_title("Genkounter")
        window.show_all()
        cmbtmodl.set_sort_column_id(1, gtk.SORT_DESCENDING)
        addcmbt.connect('clicked', self.add_combatant)
        initview.append_column(gtk.TreeViewColumn("Name", gtk.CellRendererText(), text=0))
        def initcell_cdf(column, cell, model, iter):
            cell.set_property("text", "%+d" % (model.get(iter, 1)[0],))
        initcell = gtk.CellRendererText()
        initcol = gtk.TreeViewColumn("Initiative", initcell)
        initcol.set_cell_data_func(initcell, initcell_cdf)
        initview.append_column(initcol)
        for a, b in enumerate((True, False)):
            initview.get_column(a).set_expand(b)
        startenc.connect("clicked", self.new_encounter)

        self.window = window
        self.combatant_model = cmbtmodl

    def __init__(self):
        self.setup_gui()
        self.combatants = {"Marek": 3}
        self.update_model()

if __name__ == "__main__":
    MainWindow()
    gtk.main()
