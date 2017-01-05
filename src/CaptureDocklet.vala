public static void docklet_init(Plank.DockletManager manager) {
	manager.register_docklet(typeof(Capture.CaptureDocklet));
}

namespace Capture {

	public const string G_RESOURCE_PATH = "/de/hannenz/capture";

	public class CaptureDocklet : Object, Plank.Docklet {

		public unowned string get_id() {
			return "capture";
		}

		public unowned string get_name() {
			return "Capture";
		}

		public unowned string get_description() {
			return "Screen capture and screenshot docklet";
		}

		public unowned string get_icon() {
			return "camera-video"; //"media-record";
		}

		public bool is_supported() {
			return false;
		}

		public Plank.DockElement make_element(string launcher, GLib.File file) {
			return new CaptureDockItem.with_dockitem_file(file);
		}
	}
}

