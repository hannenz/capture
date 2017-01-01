using Plank;

namespace Capture {

	public class CapturePreferences : DockItemPreferences {

		[Description(nick = "framerate", blurb = "Framerate for screen capture")]
		public uint framerate;

		[Description(nick = "countdown", blurb = "Nr. of seconds  for countdown")]
		public int countdown;

		[Description(nick = "file-format", blurb = "Output file format")]
		public string file_format;

		[Description(nick = "destination", blurb = "Destination path for saving captures")]
		public string destination;

		[Description(nick = "show-notifications", blurb = "Whether to show notifications")]
		public bool show_notifications;

		[Description(nick = "copy-to-clipboard", blurb = "Whether to copy screenshots to clipboard")]
		public bool copy_to_clipboard;

		[Description(nick = "autosave", blurb = "Whether to auto save captures or ask user")]
		public bool auto_save;

		[Description(nick = "include-pointer", blurb = "Whether to include the mouse pointer")]
		public bool include_pointer;


		public CapturePreferences.with_file(GLib.File file) {
			base.with_file(file);
		}

		protected override void reset_properties() {
			framerate = 10;
			countdown = 7;
			file_format = "png";
			destination = Environment.get_home_dir();
			show_notifications = true;
			copy_to_clipboard = true;
			auto_save = true;
			include_pointer = true;
		}
	}
}
