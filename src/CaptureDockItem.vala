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

	}
}
