using Plank;
using Notify;

namespace Capture {

	public class CaptureDockItem : DockletItem {

		
		private unowned CapturePreferences prefs;


		public CaptureDockItem.with_dockitem_file(GLib.File file) {
			GLib.Object(Prefs: new CapturePreferences.with_file(file));
		}

		construct {
			Logger.initialize("capture");
			Logger.DisplayLevel = LogLevel.NOTIFY;

			prefs = (CapturePreferences) Prefs;

			Icon = "media-record";
			Text = "Capture something";

			Notify.init("Capture Docklet");
		}

		public override Gee.ArrayList<Gtk.MenuItem> get_menu_items() {
			var items = new Gee.ArrayList<Gtk.MenuItem>();
			
			var item = create_menu_item("Screenshot region", "", true);
			item.activate.connect( () => {

				int countdown = 0;

				if (countdown == 0) {
					shot();
				}
				else {

					CountVisible = true;
					ProgressVisible = true;

					Count = countdown;
					Progress = 0;
					Timeout.add_seconds(1, () => {
					
						Count = --countdown;
						Progress = (3.0 - (double)countdown) / 3.0;

						switch (countdown) {
							case 0:
								shot();
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
				}
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

		protected void shot() {

			var grabber = new ScreenGrabber.from_region();
			grabber.grabbed.connect( (pixbuf) => {
				
				if (pixbuf == null) {
					Logger.notification("Pixbuf is null");
					Logger.notification("Aborted.");

					return;
				}


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


					if (prefs.show_notifications) {
						var notification = new Notify.Notification("Screenshot has been saved", filename, "dialog-information");
						notification.set_image_from_pixbuf(pixbuf);
						/* notification.add_action("action-name", "Open", (notification, action) => { */
						/* 	try { */
						/* 		notification.close(); */
						/* 	} */
						/* 	catch (Error e) { */
						/* 		warning(e.message); */
						/* 	} */
							// Launch system image viewer
						/* }); */
						notification.show();

						AppInfo appinfo = AppInfo.get_default_for_type("image/png", true);
						Logger.notification(appinfo.get_name());
						Logger.notification(appinfo.get_commandline());
						var files = new List<File>();
						files.append(GLib.File.new_for_path(filename));
						appinfo.launch(files, null);
					}

				}
				catch (Error e) {
					warning(e.message);
				}
			});
		}


		protected override AnimationType on_scrolled(Gdk.ScrollDirection dir, Gdk.ModifierType mod, uint32 event_time) {
			return AnimationType.NONE;
		}

		protected override AnimationType on_clicked(PopupButton button, Gdk.ModifierType mod, uint32 event_time) {
			if (button == PopupButton.LEFT) {
				shot();
				return AnimationType.BOUNCE;
			}
			return AnimationType.NONE;
		}
	}
}
