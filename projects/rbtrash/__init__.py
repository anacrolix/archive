import gtk, rb, rhythmdb

uiString = """
<ui>
	<popup name="RhythmboxIndicator">
		<placeholder name="TrackControlPlaceholder">
			<menuitem name="TrashPlayingTrack" action="TrashPlayingTrack"/>
		</placeholder>
	</popup>
</ui>
"""

class RBTrashPlugin(rb.Plugin):
	def activate(self, shell):
		uiManager = shell.get_ui_manager()
		action = gtk.Action(
				"TrashPlayingTrack",
				_("Trash Current Track"),
				_("Trash currently playing track"),
				"user-trash")
		action.connect(
				"activate",
				self.trash_playing_track,
				shell)
		self.actionGroup = gtk.ActionGroup("RBTrashPluginActions")
		self.actionGroup.add_action(action)
		uiManager.insert_action_group(self.actionGroup)
		self.uiMergeId = uiManager.add_ui_from_string(uiString)
		uiManager.ensure_update()
	def deactivate(self, shell):
		uiManager = shell.get_ui_manager()
		uiManager.remove_ui(self.uiMergeId)
		uiManager.remove_action_group(self.actionGroup)
		del self.actionGroup, self.uiMergeId
	def trash_playing_track(self, action, shell):
		playingEntry = shell.get_player().get_playing_entry()
		if playingEntry:
			defaultDb = shell.get_property("db")
			rhythmdb.RhythmDB.entry_move_to_trash(defaultDb, playingEntry)
