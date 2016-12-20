/* libdocklet-capture.so.vapi generated by valac 0.34.4, do not modify. */

namespace Capture {
	[CCode (cheader_filename = "src/CaptureDocklet.h")]
	public class CaptureDockItem : Plank.DockletItem {
		public CaptureDockItem ();
		public override Gee.ArrayList<Gtk.MenuItem> get_menu_items ();
		protected override Plank.AnimationType on_clicked (Plank.PopupButton button, Gdk.ModifierType mod, uint32 event_time);
		protected override Plank.AnimationType on_scrolled (Gdk.ScrollDirection dir, Gdk.ModifierType mod, uint32 event_time);
		protected void take_screencapture ();
		protected void take_screenshot ();
		public CaptureDockItem.with_dockitem_file (GLib.File file);
	}
	[CCode (cheader_filename = "src/CaptureDocklet.h")]
	public class CaptureDocklet : GLib.Object, Plank.Docklet {
		public CaptureDocklet ();
	}
	[CCode (cheader_filename = "src/CaptureDocklet.h")]
	public class CapturePreferences : Plank.DockItemPreferences {
		public uint countdown;
		public string destination;
		public string file_format;
		[Description (blurb = "Framerate for screen capture", nick = "framerate")]
		public uint framerate;
		public CapturePreferences ();
		protected override void reset_properties ();
		public CapturePreferences.with_file (GLib.File file);
	}
	[CCode (cheader_filename = "src/CaptureDocklet.h")]
	public const string G_RESOURCE_PATH;
}
[CCode (cheader_filename = "src/CaptureDocklet.h")]
public static void docklet_init (Plank.DockletManager manager);
