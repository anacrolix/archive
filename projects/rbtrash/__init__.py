import gtk
import rb, rhythmdb

uiString = """
<ui>
	<popup name="RhythmboxIndicator">
		<placeholder name="TrackControlPlaceholder" position="top">
			<menuitem name="TrashPlayingTrack" action="TrashPlayingTrack"/>
		</placeholder>
	</popup>
</ui>
"""

class RBTrashPlugin(rb.Plugin):
	def activate(self, shell):
		shellPlayer = shell.get_player()
		uiManager = shell.get_ui_manager()
		#iconTheme = gtk.icon_theme_get_default()
		#iconSize = gtk.icon_size_lookup(gtk.ICON_SIZE_MENU)[0]
		#icon = rb.try_load_icon(iconTheme, "user-trash", iconSize, 0)
		#print icon
		action = gtk.Action(
				"TrashPlayingTrack",
				_("Trash Current Track"),
				_("Trash currently playing track"),
				None)#"user-trash")
		action.set_icon_name("user-trash")
		action.connect(
				"activate",
				self.trash_playing_track,
				shell)
		action.set_sensitive(shellPlayer.get_playing())
		self.actionGroup = gtk.ActionGroup("RBTrashPluginActions")
		self.actionGroup.add_action(action)
		uiManager.insert_action_group(self.actionGroup)
		self.uiMergeId = uiManager.add_ui_from_string(uiString)
		self.handlerId = shellPlayer.connect(
				"playing-changed",
				self.playing_changed)
		uiManager.ensure_update()

	def deactivate(self, shell):
		uiManager = shell.get_ui_manager()
		uiManager.remove_ui(self.uiMergeId)
		uiManager.remove_action_group(self.actionGroup)
		shell.get_player().disconnect(self.handlerId)
		del self.actionGroup, self.uiMergeId, self.handlerId
		uiManager.ensure_update()

	def trash_playing_track(self, action, shell):
		playingEntry = shell.get_player().get_playing_entry()
		if playingEntry:
			defaultDb = shell.get_property("db")
			rhythmdb.RhythmDB.entry_move_to_trash(defaultDb, playingEntry)

	def playing_changed(self, shell, playing):
		print shell, playing
		trashAction = self.actionGroup.get_action("TrashPlayingTrack")
		trashAction.set_sensitive(playing)
