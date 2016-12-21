using Plank;

namespace Capture {

	public class CaptureDockItem : DockletItem {

		public ScreenGrabber grabber;

		public CaptureDockItem.with_dockitem_file(GLib.File file) {
			GLib.Object(Prefs: new CapturePreferences.with_file(file));
		}

		construct {
			Logger.initialize("capture");
			Logger.DisplayLevel = LogLevel.NOTIFY;

			grabber = new ScreenGrabber();

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

				int countdown = 3;

				CountVisible = true;
				ProgressVisible = true;

				Count = countdown;
				Progress = 0;

				Timeout.add_seconds(1, () => {
				
					Count = --countdown;
					Progress = (3.0 - (double)countdown) / 3.0;

					switch (countdown) {
						case 0:

							var pixbuf = grabber.take_screenshot();

							var now = new DateTime.now_local();
							var filename = Path.build_path(
								Path.DIR_SEPARATOR_S, 
								Environment.get_home_dir(),
								"%s%s.%s".printf(
									"capture-", 
									now.to_string(),
									"png"
								)
							);
							
							Logger.notification("Saving Screenshot to %s".printf(filename));

							try {
								pixbuf.save(filename, "png");

								// Launch system image viewer
								AppInfo appinfo = AppInfo.get_default_for_type("image/png", true);
								Logger.notification(appinfo.get_name());
								Logger.notification(appinfo.get_commandline());
								var files = new List<File>();
								files.append(GLib.File.new_for_path(filename));
								appinfo.launch(files, null);
							}
							catch (Error e) {
								warning(e.message);
							}
							

							
							return true;

						case -1:
							CountVisible = false;
							ProgressVisible = false;
							return false;

						default:
							Logger.notification("%.2f".printf(Progress));
							return true;
					}
				}, Priority.DEFAULT);
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
