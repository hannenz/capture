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
		private Pixbuf cursor_pixbuf;
		private int cursor_x;
		private int cursor_y;

		public bool include_cursor { get; set; }
		public Pixbuf pixbuf { get; set; }
		public ScreenGrabMode mode {get; set; }


		public signal void grabbed(Pixbuf? pixbuf);


		public ScreenGrabber(ScreenGrabMode mode, bool include_cursor) {
			
			this.mode = mode;
			this.include_cursor = include_cursor;

			Logger.notification("include_cursor=%s".printf(include_cursor.to_string()));

		}


		public Pixbuf grab(Gdk.Rectangle? selection) {

			default_display = Display.get_default();
			default_screen = default_display.get_default_screen();

			if (include_cursor) {
				// FIXME!!!! Use real cursor! 
				// Seems to be a problem since all known Screenshot tools can't do it (get Gdk WindowTree of another application seems not to be possible
				var crsr = new Gdk.Cursor.for_display(default_display, Gdk.CursorType.LEFT_PTR);
				
				/* for (Gdk.Window win = default_display.get_window_at_pointer(null, null); win != null; win = win.get_parent()) { */
				/* 	Logger.notification("Retrieving parent window"); */
				/* 	crsr = win.get_cursor();  */
				/* 	if (crsr != null) { */
				/* 		break; */
				/* 	} */
				/* } */

				if (crsr == null) {
					Logger.notification("The cursor is NULL");
				}

				cursor_pixbuf = crsr.get_image();
				if (cursor_pixbuf == null) {
					Logger.notification("*** OH NOES! cursor_pixbuf is NULL! ***");
				}
				Gdk.get_default_root_window().get_device_position(Display.get_default().get_device_manager().get_client_pointer(), out cursor_x, out cursor_y, null);
			}

			pixbuf = null;

			switch (mode) {
				case ScreenGrabMode.DESKTOP:
					var window = Gdk.get_default_root_window();
					pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
					if (include_cursor) {
						Gdk.get_default_root_window().get_device_position(Display.get_default().get_device_manager().get_client_pointer(), out cursor_x, out cursor_y, null);
						int dx = cursor_x;
						int dy = cursor_y;
						cursor_pixbuf.composite(pixbuf, 0, 0, pixbuf.get_width(), pixbuf.get_height(), dx - 6, dy - 6, 1.0, 1.0, InterpType.BILINEAR, 255);
					}
					grabbed(pixbuf);
					/* window = Gdk.get_default_root_window(); */
					break;

				case ScreenGrabMode.WINDOW:
					// Todo: get_acive_window() is deprecated. Find an alternative!
					var window = default_screen.get_active_window();
					int winx, winy;
					window.get_position(out winx, out winy);
					pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
					if (include_cursor) {
						Gdk.get_default_root_window().get_device_position(Display.get_default().get_device_manager().get_client_pointer(), out cursor_x, out cursor_y, null);
						int dx = cursor_x - winx;
						int dy = cursor_y - winy;
						cursor_pixbuf.composite(pixbuf, 0, 0, pixbuf.get_width(), pixbuf.get_height(), dx - 6, dy - 6, 1.0, 1.0, InterpType.BILINEAR, 255);
					}
					grabbed(pixbuf);
					break;

				case ScreenGrabMode.REGION:
					if (selection != null) {
						var window = Gdk.get_default_root_window();
						pixbuf = Gdk.pixbuf_get_from_window(window, selection.x, selection.y, selection.width, selection.height);

						if (include_cursor) {

							Gdk.get_default_root_window().get_device_position(Display.get_default().get_device_manager().get_client_pointer(), out cursor_x, out cursor_y, null);
							int dx = cursor_x - selection.x;
							int dy = cursor_y - selection.y;
							
							cursor_pixbuf.composite(pixbuf, 0, 0, pixbuf.get_width(), pixbuf.get_height(), dx - 6, dy - 6, 1.0, 1.0, InterpType.BILINEAR, 255);
						}
					}

					grabbed(pixbuf);
					break;

				default:
					break;
			}

			return pixbuf;
		}

		public ScreenGrabber.from_region (bool include_cursor) {
			this(ScreenGrabMode.REGION, include_cursor);
		}

		public ScreenGrabber.from_window(bool include_cursor) {
			this(ScreenGrabMode.WINDOW, include_cursor);
		}

		public ScreenGrabber.from_desktop(bool include_cursor) {
			this(ScreenGrabMode.DESKTOP, include_cursor);
		}

	}
}
