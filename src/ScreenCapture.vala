using Gdk;

namespace Capture {

	public class ScreenCapture {

		Gdk.Window window;
		Gdk.Pixbuf pixbuf;

		public ScreenCapture() {
			window = Gdk.get_default_root_window();
			pixbuf = null;
		}

		protected  Gdk.Pixbuf take_screenshot() {
			pixbuf = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
			return pixbuf;

			try {
				pixbuf.save(filename, "png");
			}
			catch (Error e) {
				warning("Could not write pixbuf to file: " + filename);
			}
			return  pixbuf;
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
