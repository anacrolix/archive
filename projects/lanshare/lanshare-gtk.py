#!/usr/bin/env python

import os
import pdb
import time

if os.name == "nt":
    # put possible local copy of gtk dlls on path
    os.environ["PATH"] += os.pathsep + r"gtk\bin"
import glib
import gtk

from lanshare import Lanshare

def stock_image(stock_id):
    image = gtk.Image()
    image.set_from_stock(stock_id, gtk.ICON_SIZE_BUTTON)
    return image

class LanshareGtk(Lanshare):

    __slots__ = "peerstore", "sharestore", "shareview", "peersock"

    # remove peer if announce isn't received for this long
    peer_timeout = 10
    # send out announces and check timeouts with this interval
    peer_announce_interval = 3

    def create_gui(self):
        # store contains (virtual dir name, actual fs path)
        sharestore = gtk.ListStore(str, str)

        shareview = gtk.TreeView(sharestore)
        shareview.insert_column_with_attributes(
                -1, "Share Name", gtk.CellRendererText(), text=0)
        shareview.insert_column_with_attributes(
                -1, "Local Path", gtk.CellRendererText(), text=1)
        shareview.get_selection().set_mode(gtk.SELECTION_MULTIPLE)

        addshrbtn = gtk.Button("New Share", stock=gtk.STOCK_ADD)
        addshrbtn.connect("clicked", self.add_share)

        remshrbtn = gtk.Button("Remove Share", stock=gtk.STOCK_REMOVE)
        remshrbtn.connect("clicked", self.remove_share)

        sharebtns = gtk.VButtonBox()
        sharebtns.add(addshrbtn)
        sharebtns.add(remshrbtn)
        sharebtns.set_layout(gtk.BUTTONBOX_START)

        sharepage = gtk.HBox()
        sharepage.add(shareview)
        sharepage.pack_start(sharebtns, expand=False)

        # hostname, host, serv, lasttime, protocol
        peerstore = gtk.ListStore(str, str, int, float, str)
        # could do this manually and wrap a dict of this format:
        #   {(hostname, host, serv, protocol): lasttime}
        #peerstore = gtk.GenericTreeModel()

        peerview = gtk.TreeView(peerstore)
        peerview.insert_column_with_attributes(
                -1, "Peer Name", gtk.CellRendererText(), text=0)
        peerview.insert_column_with_data_func(
                 -1, "Network Address", gtk.CellRendererText(),
                 self.peer_view_network_address_cell_data_func)
        peerview.connect("row-activated", self.peer_view_row_activated)

        browse_peer_button = gtk.Button("Browse")
        browse_peer_button.set_image(stock_image(gtk.STOCK_HARDDISK))
        browse_peer_button.connect("clicked", self.browse_peer_button_clicked, peerview)

        refresh_peers_button = gtk.Button("Refresh")
        refresh_peers_button.set_image(stock_image(gtk.STOCK_FIND))
        refresh_peers_button.connect(
                "clicked",
                lambda button: self.send_peer_announce)

        peer_buttons = gtk.VButtonBox()
        peer_buttons.add(browse_peer_button)
        peer_buttons.add(refresh_peers_button)
        peer_buttons.set_layout(gtk.BUTTONBOX_START)

        peers_page = gtk.HBox()
        peers_page.pack_start(peerview)
        peers_page.pack_start(peer_buttons, expand=False)

        notebook = gtk.Notebook()
        notebook.append_page(sharepage)
        notebook.set_tab_label_text(sharepage, "Shares")
        notebook.append_page(peers_page)
        notebook.set_tab_label_text(peers_page, "Peers")

        window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window.connect("destroy", self.destroy)
        window.add(notebook)
        window.set_title(self.__title__)
        window.show_all()

        # save these for later manipulation
        self.peerstore = peerstore
        self.sharestore = sharestore
        self.shareview = shareview

    def browse_peer_by_url(self, url):
        """Open the given peer URL with the most natural file manager for the
        current platform that we can find"""
        import os, subprocess
        if os.name == "nt":
            # this is how it's done programmatically? except that it won't invoke
            # the default file manager (explorer) on winders
            #ShellExecute(None, "explore", url, None, None, SW_SHOWNORMAL)

            # invoke explorer directly. why does it return 1 on success?
            if subprocess.call(["explorer", url]) == 1:
                return
        # this goes through to gnome-open on gnome, neither of which automatically
        # mount it, and complain that the address isn't available
        subprocess.check_call(["xdg-open", url])

        # explicitly invoking the file manager works as intended, as with the
        # windows explorer
        subprocess.check_call(["nautilus", url])

        # fall back to using the preferred browser
        import webbrowser
        webbrowser.open(url)

    def peer_view_row_activated(self, view, path, column):
        self.browse_peer_by_url(self.get_peer_url(view.get_model()[path]))

    def browse_peer_button_clicked(self, button, view):
        model, iter = view.get_selection().get_selected()
        self.browse_peer_by_url(self.get_peer_url(model[iter]))

    def get_peer_url(self, peer_store_row):
        """Return a complete URL from a given row in the peer view"""
        from urlparse import urlunsplit
        # why must the network location be built manually? this will need to be
        # modified if it is to support IPv6 addresses correctly
        return urlunsplit((
                peer_store_row[4],
                "{0}:{1}".format(peer_store_row[1], peer_store_row[2]),
                "", "", ""))

    def peer_view_network_address_cell_data_func(self, column, cell, model, iter):
        text = self.get_peer_url(model[iter])
        #print text
        cell.set_property("text", text)
        #cell.text =

    def create_peer_socket(self):
        import socket
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, True)
        sock.bind(("", self.port))

        glib.io_add_watch(
                sock,
                glib.IO_IN,
                self.peer_socket_event)

        self.peersock = sock
        #self.peeraddrs = set()

        self.send_peer_announce()

    def send_peer_announce(self):
        import socket
        try:
            self.peersock.sendto(
                    repr({"protocol": "ftp", "hostname": socket.gethostname()}),
                    ("255.255.255.255", self.port))
        except socket.error as exc:
            import traceback
            traceback.print_exc()

    def peer_socket_event(self, source, condition):
        if condition & glib.IO_IN:
            data, addr = self.peersock.recvfrom(0x100)
            recvtime = time.time()
            data = eval(data)
            hostname = data["hostname"]
            protocol = data["protocol"]
            for row in self.peerstore:
                # find matching row
                if      row[0] == hostname and \
                        row[1] == addr[0] and \
                        row[2] == addr[1] and \
                        row[4] == protocol:
                    # update the announce recv time
                    row[3] = recvtime
                    break
            else:
                # no peer match found, so add it
                self.peerstore.append(
                        (hostname, addr[0], addr[1], recvtime, protocol))
        return True

    def __init__(self):
        Lanshare.__init__(self)

        self.create_gui()
        self.create_peer_socket()

        from glib import idle_add, timeout_add_seconds
        idle_add(self.gui_idle)
        timeout_add_seconds(self.peer_announce_interval, self.peer_tick)

        self.populate_shares()

    def peer_tick(self):
        try:
            self.send_peer_announce()
            from time import time
            delrefs = []
            for row in self.peerstore:
                if time() >= row[3] + self.peer_timeout:
                    delrefs.append(gtk.TreeRowReference(row.model, row.path))
            for ref in delrefs:
                del self.peerstore[ref.get_path()]
        except:
            import traceback
            traceback.print_exc()
        finally:
            return True

    def populate_shares(self):
        self.sharestore.clear()
        for virtdir, shrroot in self.config.shares.iteritems():
            self.sharestore.append((virtdir, shrroot))

    def add_share(self, button):
        namelbl = gtk.Label("Share name:")

        entry = gtk.Entry()

        pathlbl = gtk.Label("Actual path:")

        pathdlg = gtk.FileChooserDialog(
                "Select Share Root",
                parent=None,
                action=gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER,
                buttons=(
                    gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                    gtk.STOCK_OPEN, gtk.RESPONSE_ACCEPT),)

        pathbtn = gtk.FileChooserButton(pathdlg)

        table = gtk.Table(rows=2, columns=2)
        table.attach(namelbl, 0, 1, 0, 1)
        table.attach(entry, 1, 2, 0, 1)
        table.attach(pathlbl, 0, 1, 1, 2)
        table.attach(pathbtn, 1, 2, 1, 2)

        dialog = gtk.Dialog(
                title="Create New Share",
                parent=None,
                flags=gtk.DIALOG_MODAL|gtk.DIALOG_DESTROY_WITH_PARENT,
                buttons=(
                    gtk.STOCK_NEW, gtk.RESPONSE_OK,
                    gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL))
        dialog.set_default_response(gtk.RESPONSE_OK)
        dialog.vbox.pack_start(table)
        dialog.vbox.show_all()

        response = dialog.run()
        #pdb.set_trace()
        if response == gtk.RESPONSE_OK:
            shrroot = pathdlg.get_filename()
            virtdir = entry.get_text()
            if shrroot and virtdir:
                self.config.shares[virtdir] = shrroot
                self.populate_shares()

        dialog.destroy()

    def remove_share(self, widget=None):
        store, rowpaths = self.shareview.get_selection().get_selected_rows()
        # reverse the paths so we delete from the back, so as not to invalidate
        # paths that come earlier
        for path in reversed(rowpaths):
            # the first column of the store contains the key
            del self.config.shares[store[path][0]]
        self.populate_shares()

    def gui_idle(self):
        try:
            self.server.serve_forever(use_poll=True, count=1, timeout=0.02)
            return True
        except KeyboardInterrupt:
            import traceback
            traceback.print_exc()
            self.destroy()

    def destroy(self, widget=None):
        print "Main window destroyed"
        self.server.close_all()
        gtk.main_quit()

    def __call__(self):
        #Lanshare.__call__(self)

        gtk.main()

if __name__ == "__main__":
    LanshareGtk()()
