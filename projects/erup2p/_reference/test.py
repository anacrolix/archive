import gtk
import gobject

d = gtk.MessageDialog(buttons=gtk.BUTTONS_YES_NO)
d.connect("response", lambda a, b: b.destroy())
#gtk.Widget.destroy(d)
print d.run()
while True: pass
