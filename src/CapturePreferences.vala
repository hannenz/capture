using Plank;

namespace Capture {
	public class CapturePreferences : DockItemPreferences {
		[Description(nick = "framerate", blurb="Framerate for screen capture")]
		public uint framerate;

		public int countdown;

		public string file_format;

		public string destination;


		public bool show_notifications;


		public CapturePreferences.with_file(GLib.File file) {
			base.with_file(file);
		}

		protected override void reset_properties() {
			framerate = 10;
			countdown = 3;
			file_format = "png";
			destination = Environment.get_home_dir();
			show_notifications = true;
		}
	}
}
