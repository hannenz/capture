using Gdk;

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

		public Pixbuf pixbuf { get; set; }
		public ScreenGrabMode mode {get; set; }

		public ScreenGrabber() {
			default_display = Display.get_default();
			default_screen = default_display.get_default_screen();

			pixbuf = null;
		}

		public  Gdk.Pixbuf take_screenshot() {

			switch (mode) {
				case ScreenGrabMode.DESKTOP:
					window = Gdk.get_default_root_window();
					break;

				case ScreenGrabMode.WINDOW:
					window = default_screen.get_active_window();
					break;
				default:
					break;
			}

			pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
			return pixbuf;
		}

		public void take_screencapture() {
		}
	}
}
