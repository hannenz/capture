using Plank;

namespace Capture {

	public class CaptureDockItem : DockletItem {

		public CaptureDockItem.with_dockitem_file(GLib.File file) {
			GLib.Object(Prefs: new CapturePreferences.with_file(file));
		}

		construct {
			Logger.initialize("capture");
			Logger.DisplayLevel = LogLevel.NOTIFY;

			unowned CapturePreferences prefs = (CapturePreferences) Prefs;

			Icon = "media-record";
			Text = "Capture something";

			updated();
		}


		void updated() {
			return;
		}

		public override Gee.ArrayList<Gtk.MenuItem> get_menu_items() {
			var items = new Gee.ArrayList<Gtk.MenuItem>();
			
			var item = create_menu_item("Screenshot", "", true);
			item.activate.connect( () => {
				Logger.notification("Screenshot");
				take_screenshot();
			});
			items.add(item);

			item = create_menu_item("Screen Capture", "", true);
			item.activate.connect( () => {
				Logger.notification("Screen Capture");
			});
			items.add(item);

			item = create_menu_item("Settings", "", true);
			item.activate.connect( () => {
				Logger.notification("Settings");
			});
			items.add(item);

			return items;
		}


		protected override AnimationType on_scrolled(Gdk.ScrollDirection dir, Gdk.ModifierType mod, uint32 event_time) {
			return AnimationType.NONE;
		}

		protected override AnimationType on_clicked(PopupButton button, Gdk.ModifierType mod, uint32 event_time) {
			if (button == PopupButton.LEFT) {
				return AnimationType.BOUNCE;
			}
			return AnimationType.NONE;
		}

		protected void take_screenshot() {
			Gdk.Window window = Gdk.get_default_root_window();
			Gdk.Pixbuf pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
			var now = new DateTime.now_local();
			string filename = Path.build_path(Path.DIR_SEPARATOR_S, Environment.get_tmp_dir(), "capture-%s.png".printf(now.format("%Y-%m-%d-%H%M%S")));
			try {
				Logger.notification("Saving file to " + filename);
				pixbuf.save(filename, "png");
			}
			catch (Error e) {
				warning("Could not write pixbuf to file: " + filename);
			}
		}

		protected void take_screencapture() {
			Timeout.add_full(Priority.DEFAULT, 1/10 * 1000, () => {
				Gdk.Window window = Gdk.get_default_root_window();
				Gdk.Pixbuf pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
				return true;
			});
		}
	}
}
