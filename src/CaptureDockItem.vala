using Plank;
using Notify;
using Gdk;
using Gtk;

namespace Capture {

	public class CaptureDockItem : DockletItem {

		private unowned CapturePreferences prefs;
		private ScreenGrabMode mode;
		private Gtk.Clipboard clipboard;
		private Gdk.Rectangle? selection;
		private Sequence sequence;


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

			clipboard = Gtk.Clipboard.get(Gdk.Atom.intern("CLIPBOARD", true));

			mode = ScreenGrabMode.DESKTOP;
			selection = null;

			/* sequence = new Sequence(); */
		}

		public override Gee.ArrayList<Gtk.MenuItem> get_menu_items() {
			var items = new Gee.ArrayList<Gtk.MenuItem>();
			
			var item = create_menu_item("Screenshot Region", "", true);
			item.activate.connect( () => {
				take_screenshot(ScreenGrabMode.REGION);
			});
			items.add(item);

			item = create_menu_item("Screenshot Active Window", "", true);
			item.activate.connect(() => {
				take_screenshot(ScreenGrabMode.WINDOW);
			});
			items.add(item);

			item = create_menu_item("Screenshot Desktop", "", true);
			item.activate.connect( () => {
				take_screenshot(ScreenGrabMode.DESKTOP);
			});
			items.add(item);

			item = create_menu_item("Screen Capture Region", "", true);
			item.activate.connect( () => {
				take_screencapture(ScreenGrabMode.REGION);
			});
			items.add(item);
			item = create_menu_item("Screen Capture Active Window", "", true);
			item.activate.connect( () => {
				take_screencapture(ScreenGrabMode.WINDOW);
			});
			items.add(item);
			item = create_menu_item("Screen Capture Desktop", "", true);
			item.activate.connect( () => {
				take_screencapture(ScreenGrabMode.DESKTOP);
			});
			items.add(item);

			item = create_menu_item("Settings", "", true);
			item.activate.connect( () => {
				Logger.notification("Settings");
			});
			items.add(item);

			return items;
		}

		protected void take_screenshot(ScreenGrabMode? mode) {

			if (mode != null) {
				this.mode = mode;
			}
			RegionSelect region_select = null;
			selection = null;

			if (this.mode == ScreenGrabMode.REGION) {
				region_select = new RegionSelect();
				selection = region_select.run();
			}

			ProgressVisible = true;
			CountVisible = true;
			Count = prefs.countdown;
			Progress = 0;
			
			Logger.notification("prefs.countdown = %u".printf(prefs.countdown));
			var countdown = new Countdown(prefs.countdown);

			countdown.tick.connect( (second, progress) => {
				Count = second;
				Progress = progress;
			});

			countdown.ignition.connect( () => {
				if (this.mode == ScreenGrabMode.REGION) {
					region_select.destroy();
				}
				shot();
				ProgressVisible = false;
				CountVisible = false;
			});
			countdown.start();
		}


		protected void shot() {
			
			ScreenGrabber grabber;
			Pixbuf pixbuf;

			switch (mode) {
				case ScreenGrabMode.REGION:
					grabber = new ScreenGrabber.from_region();
					break;
				case ScreenGrabMode.WINDOW:
					grabber = new ScreenGrabber.from_window();
					break;
				case ScreenGrabMode.DESKTOP:
					grabber = new ScreenGrabber.from_desktop();
					break;
				default:
					warning ("Illegal ScreenGrabMode: %u", mode);
					return;
			}
			
			pixbuf = grabber.grab(selection);
			if (pixbuf == null) {
				Logger.notification("Aborted.");
				return;
			}

			var now = new DateTime.now_local();
			string name = "%s%s.%s".printf("capture-", now.to_string(), "png");
			string filename = null;

			if (prefs.auto_save) {

				filename = Path.build_path(
					Path.DIR_SEPARATOR_S, 
					prefs.destination,
					name
				);
			}
			else {
				var chooser = new FileChooserDialog("Select destination to save the capture", null, FileChooserAction.SAVE, "_Cancel", ResponseType.CANCEL, "_Save", ResponseType.ACCEPT);
				chooser.set_current_name(name);
				if (chooser.run() == ResponseType.ACCEPT) {
					filename = chooser.get_filename();
				}
				chooser.destroy();
			}
			
			if (filename != null) {
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
			}

			if (prefs.copy_to_clipboard) {
				clipboard.set_image(pixbuf);
			}
		}

		protected void take_screencapture(ScreenGrabMode mode) {

			ScreenGrabber grabber;

			sequence = new Sequence();
			sequence.framerate = prefs.framerate.clamp(1, 30);

			switch (mode) {
				case ScreenGrabMode.REGION:
					var region_select = new RegionSelect();
					selection = region_select.run();
					region_select.destroy();
					grabber = new ScreenGrabber(ScreenGrabMode.REGION);
					break;
				default:
					grabber = new ScreenGrabber(mode);
					break;
			}

			int nframes = 100;

			Timeout.add(1000 / prefs.framerate, () => {
				sequence.add(grabber.grab(selection));
				if (--nframes <= 0) {
					/* region_select.destroy(); */
					var preview = new CapturePreview(sequence);
					preview.run();
					preview.destroy();
					return false;
				}
				return true;
			}, Priority.DEFAULT);
		}


		protected override AnimationType on_scrolled(Gdk.ScrollDirection dir, Gdk.ModifierType mod, uint32 event_time) {
			return AnimationType.NONE;
		}

		protected override AnimationType on_clicked(PopupButton button, Gdk.ModifierType mod, uint32 event_time) {
			if (button == PopupButton.LEFT) {
				take_screenshot(null);
				return AnimationType.BOUNCE;
			}
			return AnimationType.NONE;
		}
	}
}
