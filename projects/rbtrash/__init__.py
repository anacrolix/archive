import gtk
import rb, rhythmdb

uiString = """
<ui>
	<!-- this is for vanilla RB -->
    <popup name="RhythmboxTrayPopup">
		<placeholder name="PluginPlaceholder">
			<menuitem name="TrashPlayingTrack" action="TrashPlayingTrack"/>
		</placeholder>
    </popup>
	<!-- this is for Ubuntu -->
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

		trashAction = gtk.Action(
				"TrashPlayingTrack",
				_("Trash Current Track"),
				_("Trash currently playing track"),
				None)#"user-trash")
		trashAction.set_icon_name("user-trash")
		trashAction.connect(
				"activate",
				self.trash_playing_track,
				shell)
		trashAction.set_sensitive(shellPlayer.get_playing())
		self.actionGroup = gtk.ActionGroup("RBTrashPluginActions")
		self.actionGroup.add_action(trashAction)
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
		if not playingEntry:
			return

		# can also get this from shell.props.db?
		defaultDb = shell.get_property("db")

		title = defaultDb.entry_get(playingEntry, rhythmdb.PROP_TITLE)
		artist = defaultDb.entry_get(playingEntry, rhythmdb.PROP_ARTIST)
		album = defaultDb.entry_get(playingEntry, rhythmdb.PROP_ALBUM)
		primaryText = title or "<Unknown Title>"
		secondaryText = "by {0}\nfrom {1}".format(
				artist or "<Unknown Artist>",
				album or "<Unknown Album>")
		del title, artist, album

		if hasattr(self, "dialog"):
			self.dialog.destroy()
		self.dialog = gtk.MessageDialog(
				parent=shell.props.window,
				type=gtk.MESSAGE_QUESTION,
				flags=gtk.DIALOG_DESTROY_WITH_PARENT|gtk.DIALOG_MODAL,
				message_format=primaryText)
		self.dialog.format_secondary_text(secondaryText)
		self.dialog.set_title("Move to Trash?")
		self.dialog.add_buttons(
				gtk.STOCK_DELETE, gtk.RESPONSE_ACCEPT,
				gtk.STOCK_CANCEL, gtk.RESPONSE_REJECT)
		self.dialog.connect(
				"response",
				self.trash_dialog_response,
				defaultDb, playingEntry)
		self.dialog.show()

	def trash_dialog_response(self, dialog, response, rhythmDb, entry):
		dialog.destroy()
		if response == gtk.RESPONSE_ACCEPT:
			rhythmDb.entry_move_to_trash(entry)

	def playing_changed(self, shell, playing):
		trashAction = self.actionGroup.get_action("TrashPlayingTrack")
		trashAction.set_sensitive(playing)
