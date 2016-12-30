using Gdk;
using Plank;

namespace Capture {

	public enum ScreenGrabMode {
		DESKTOP,
		WINDOW,
		REGION
	}

	public class ScreenGrabber {

		private Display default_display;
		private Screen default_screen; 
		private Window window;
		private Pixbuf cursor_pixbuf;
		private int cursor_x;
		private int cursor_y;

		public Pixbuf pixbuf { get; set; }
		public ScreenGrabMode mode {get; set; }

		public signal void grabbed(Pixbuf? pixbuf);


		public ScreenGrabber(ScreenGrabMode mode) {
			this.mode = mode;

			default_display = Display.get_default();
			default_screen = default_display.get_default_screen();
			var crsr = new Gdk.Cursor.for_display(default_display, Gdk.CursorType.LEFT_PTR);
			cursor_pixbuf = crsr.get_image();
			if (cursor_pixbuf == null) {
				Logger.notification("*** OH NOES! cursor_pixbuf is NULL! ***");
			}
			Gdk.get_default_root_window().get_device_position(Display.get_default().get_device_manager().get_client_pointer(), out cursor_x, out cursor_y, null);

			pixbuf = null;

			switch (mode) {
				case ScreenGrabMode.DESKTOP:
					window = Gdk.get_default_root_window();
					break;

				case ScreenGrabMode.WINDOW:
					// Todo: get_acive_window() is deprecated. Find an alternative!
					/* window = default_screen.get_active_window(); */
					break;

				case ScreenGrabMode.REGION:
					var region_select = new RegionSelect();
					region_select.selected.connect( (selection) => {
						
						region_select.destroy();
						if (selection != null) {
							window = Gdk.get_default_root_window();
							pixbuf = Gdk.pixbuf_get_from_window(window, selection.x, selection.y, selection.width, selection.height);
						}

						Logger.notification("Adding cursor");
						add_cursor();

						grabbed(pixbuf);
					});

					region_select.present();
					break;

				default:
					break;
			}

			if (pixbuf == null) {
				pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
			}
			grabbed(pixbuf);
		}

		public ScreenGrabber.from_region () {
			this(ScreenGrabMode.REGION);
		}

		public ScreenGrabber.from_window() {
			this(ScreenGrabMode.WINDOW);
		}

		public ScreenGrabber.from_desktop() {
			this(ScreenGrabMode.DESKTOP);
		}

		private void add_cursor() {
			cursor_pixbuf.composite(pixbuf, 10, 10, 100, 100, 0, 0, 1.0, 1.0, InterpType.BILINEAR, 255);
		}

		/* public void take_screencapture() { */
		/* } */
	}
}
