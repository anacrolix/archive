#!/usr/bin/env python
import pygtk
pygtk.require('2.0')

import gtk
import gnomeapplet
import gobject

def background_show(applet):
    print "background: ", applet.get_background()

def sample_factory(applet, iid):
    print "Creating new applet instance"
    label = gtk.Label("Success!")
    applet.add(label)
    applet.show_all()
    gobject.timeout_add(1000, background_show, applet)
    return True

print "Starting factory"
gnomeapplet.bonobo_factory("OAFIID:GNOME_PythonAppletSample_Factory", 
                           gnomeapplet.Applet.__gtype__, 
                           "hello", "0", sample_factory)
print "Factory ended"

