using Plank;
using Notify;
using Gdk;
using Gtk;

namespace Capture {

	public class CaptureDockItem : DockletItem {

		/* private unowned CapturePreferences prefs; */
		private ScreenGrabMode mode;
		private Gtk.Clipboard clipboard;
		private Gdk.Rectangle? selection;
		private Sequence sequence;
		private GLib.Settings settings;
		private bool capturing = false;

		public CaptureDockItem.with_dockitem_file(GLib.File file) {
			GLib.Object(Prefs: new CapturePreferences.with_file(file));
		}

		construct {
			Logger.initialize("capture");
			Logger.DisplayLevel = LogLevel.NOTIFY;

			/* prefs = (CapturePreferences) Prefs; */

			/* Icon = "media-record"; */
			Icon = "camera-video";
			Text = "Capture something";

			Notify.init("Capture Docklet");

			clipboard = Gtk.Clipboard.get(Gdk.Atom.intern("CLIPBOARD", true));

			mode = ScreenGrabMode.DESKTOP;
			selection = null;

			settings = new GLib.Settings("de.hannenz.capture");

			Logger.notification("GTK Version is %u.%u".printf(Gtk.get_major_version(), Gtk.get_minor_version()));
			Logger.notification("screens:  %u".printf(Display.get_default().get_n_screens()));
			Logger.notification("monitors: %u".printf(Display.get_default().get_screen(0).get_n_monitors()));
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
				var response = region_select.run();

				region_select.destroy();

				if (response == ResponseType.CANCEL) {
					return;
				}

				selection = region_select.get_selection();
			}

			ProgressVisible = true;
			CountVisible = true;
			Progress = 0;

			var c = settings.get_int("countdown");
			
			var countdown = new Countdown(c);
			Logger.notification("countdown = %u".printf(c));
			Count = c;

			countdown.tick.connect( (second, progress) => {
				Count = second;
				Progress = progress;
			});

			countdown.ignition.connect( () => {
				/* if (this.mode == ScreenGrabMode.REGION) { */
				/* 	region_select.destroy(); */
				/* } */
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

			if (settings.get_boolean("auto-save")) {

				filename = Path.build_path(
					Path.DIR_SEPARATOR_S, 
					/* prefs.destination, */
					settings.get_string("destination"),
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


					if (settings.get_boolean("show-notifications")) {
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

			if (settings.get_boolean("copy-to-clipboard")) {
				clipboard.set_image(pixbuf);
			}
		}

		protected void take_screencapture(ScreenGrabMode mode) {

			ScreenGrabber grabber;

			sequence = new Sequence();
			sequence.framerate = settings.get_int("framerate").clamp(1, 30);

			switch (mode) {
				case ScreenGrabMode.REGION:
					var region_select = new RegionSelect();
					var response = region_select.run();
					region_select.destroy();
					if (response == ResponseType.CANCEL) {
						return;
					}
					selection = region_select.get_selection();
					grabber = new ScreenGrabber(ScreenGrabMode.REGION);
					break;
				default:
					grabber = new ScreenGrabber(mode);
					break;
			}

			int nframes = 30;
			int framerate = settings.get_int("framerate");
			Logger.notification("Framerate is %d".printf(framerate));
			capturing = true;
			double duration = 0;
			CountVisible = true;

			Timeout.add(1000 / framerate, () => {
				duration += (1.0 / (double)framerate);
				Count = (int)duration; 
				Logger.notification("Shooting a frame...%.3f".printf(duration));
				sequence.add(grabber.grab(selection));

				if (capturing == false) {
					var preview = new CapturePreview(sequence);
					var response = preview.run();
					preview.destroy();
					if (response == ResponseType.ACCEPT) {
						var file_chooser = new FileChooserDialog("Save", null, FileChooserAction.SAVE, "Cancel", ResponseType.CANCEL, "Save", ResponseType.ACCEPT);
						response = file_chooser.run();
						var filename = file_chooser.get_filename();

						file_chooser.destroy();

						if(response == ResponseType.ACCEPT) {
							sequence.save_to_animated_gif(filename);
						}
					}
					CountVisible = false;
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
				if (!capturing) {
					take_screenshot(null);
				}
				else {
					capturing = false;
				}
				return AnimationType.BOUNCE;
			}
			return AnimationType.NONE;
		}
	}
}
