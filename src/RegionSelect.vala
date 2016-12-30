using Granite;
using Plank;
using Cairo;
using Gdk;

namespace Capture {

	public enum DragStatus {
		NONE,
		NORTHWEST,
		NORTHEAST,
		SOUTHEAST,
		SOUTHWEST,
		NORTH,
		EAST,
		SOUTH,
		WEST,
		MOVE
	}

	public class RegionSelect : Granite.Widgets.CompositedWindow {

		protected Gtk.DrawingArea drawing_area;
		protected Gdk.Device mouse;
		protected Gdk.Window gwin;

		private DragStatus status;
		private int delta_x;
		private int delta_y;

		public Gdk.Rectangle selection;

		public signal void selected(Gdk.Rectangle? selection);

		construct {
			resizable = true;
		}

		/**
		  * Constructor
		  */
		public RegionSelect() {

			// TODO: Place default selection in center of screen
			selection = Gdk.Rectangle();
			selection.x = 100;
			selection.y = 100;
			selection.width = 200;
			selection.height = 200;
			
			drawing_area = new Gtk.DrawingArea();
			drawing_area.draw.connect(on_draw);
			drawing_area.add_events(Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.BUTTON_MOTION_MASK | Gdk.EventMask.BUTTON1_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
			add(drawing_area);

			fullscreen();
			set_modal(true);

			var display = Display.get_default();
			var manager = display.get_device_manager();
			mouse = manager.get_client_pointer();

			status = DragStatus.NONE;

			Gdk.Cursor[] cursors = {
				new Gdk.Cursor.from_name(display, "default"),
				new Gdk.Cursor.from_name(display, "nw-resize"),
				new Gdk.Cursor.from_name(display, "ne-resize"),
				new Gdk.Cursor.from_name(display, "se-resize"),
				new Gdk.Cursor.from_name(display, "sw-resize"),
				new Gdk.Cursor.from_name(display, "n-resize"),
				new Gdk.Cursor.from_name(display, "e-resize"),
				new Gdk.Cursor.from_name(display, "s-resize"),
				new Gdk.Cursor.from_name(display, "w-resize"),
				new Gdk.Cursor.from_name(display, "move")
			};


			drawing_area.button_press_event.connect( (context) => {
				int x, y;
				Gdk.get_default_root_window().get_device_position(mouse, out x, out y, null);

				if (is_near(x, y, selection.x, selection.y, 30)) {
					status = DragStatus.NORTHWEST;
					return true;
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y, 30)) {
					status = DragStatus.NORTHEAST;
					return true;
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y + selection.height, 30)) {
					status = DragStatus.SOUTHEAST;
					return true;
				}
				else if (is_near(x, y, selection.x, selection.y + selection.height, 30)) {
					status = DragStatus.SOUTHWEST;
					return true;
				}
				else if (x >= selection.x && x < selection.x + selection.width && y > selection.y && y < selection.y + selection.height) {
					status = DragStatus.MOVE;
					delta_x = x - selection.x;
					delta_y = y - selection.y;
					return true;
				}
				else if (x >= selection.x - 15 && x <= selection.x + 15) {
					status = DragStatus.WEST;
					return true;
				}
				else if (x >= selection.x + selection.width - 15 && x <= selection.x + selection.width + 15) {
					status = DragStatus.EAST;
					return true;
				}
				else if (y >= selection.y + selection.height - 15 && y <= selection.y + selection.height + 15) {
					status = DragStatus.SOUTH;
					return true;
				}
				else if (y >= selection.y - 15 && y <= selection.y + 15) {
					status = DragStatus.NORTH;
					return true;
				}

				selection.x = x;
				selection.y = y;
				status = DragStatus.SOUTHEAST;
				return true;
			});
			
			drawing_area.motion_notify_event.connect( (event) => {
				int x, y;
				/* Gdk.get_default_root_window().get_device_position(mouse, out x, out y, null); */
				gwin.get_device_position(mouse, out x, out y, null);
				if ( is_near(x, y, selection.x, selection.y, 30)) {
					gwin.set_cursor(cursors[DragStatus.NORTHWEST]);
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y, 30)) {
					gwin.set_cursor(cursors[DragStatus.NORTHEAST]);
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y + selection.height, 30)) {  
					gwin.set_cursor(cursors[DragStatus.SOUTHEAST]);
				}
				else if (is_near(x, y, selection.x, selection.y + selection.height, 30)) {
					gwin.set_cursor(cursors[DragStatus.SOUTHWEST]);
				}
				else if (x >= selection.x && x < selection.x + selection.width && y > selection.y && y < selection.y + selection.height) {
					gwin.set_cursor(cursors[DragStatus.MOVE]);
				}
				else if (x >= selection.x - 15 && x <= selection.x + 15) {
					gwin.set_cursor(cursors[DragStatus.WEST]);
				}
				else if (x >= selection.x + selection.width - 15 && x <= selection.x + selection.width + 15) {
					gwin.set_cursor(cursors[DragStatus.EAST]);
				}
				else if (y >= selection.y + selection.height - 15 && y <= selection.y + selection.height + 15) {
					gwin.set_cursor(cursors[DragStatus.SOUTH]);
				}
				else if (y >= selection.y - 15 && y <= selection.y + 15) {
					gwin.set_cursor(cursors[DragStatus.NORTH]);
				}
				else {
					gwin.set_cursor(cursors[DragStatus.NONE]);
				}
				
				switch (status) {
					case DragStatus.NORTHWEST:
						selection.width += selection.x - x;
						selection.height += selection.y - y;
						selection.x = x;
						selection.y = y;
						break;
					case DragStatus.NORTHEAST:
						selection.width = x - selection.x;
						selection.height += selection.y - y;
						selection.y = y;
						break;
					case DragStatus.SOUTHEAST:
						selection.width = x - selection.x;
						selection.height = y - selection.y;
						break;
					case DragStatus.SOUTHWEST:
						selection.width += selection.x - x;
						selection.height = y - selection.y;
						selection.x = x;
						break;
					case DragStatus.MOVE:
						selection.x = x - delta_x;
						selection.y = y - delta_y;
						break;
					case DragStatus.NORTH:
						selection.height += selection.y - y;
						selection.y = y;
						break;
					case DragStatus.SOUTH:
						selection.height = y - selection.y;
						break;
					case DragStatus.EAST:
						selection.width = x - selection.x;
						break;
					case DragStatus.WEST:
						selection.width += selection.x - x;
						selection.x = x;
						break;
				}

				if (status != DragStatus.NONE) {
					drawing_area.queue_draw();
				}

				return true;
			});

			drawing_area.button_release_event.connect( (context) => {
				// TODO: If width / height is negative, swap coordinates (normalize to positive)
				if (selection.width < 0) {
					selection.width = selection.width.abs();
					selection.x -= selection.width;
				}
				if (selection.height < 0) {
					selection.height = selection.height.abs();
					selection.y -= selection.height;
				}

				status = DragStatus.NONE;
				return true;
			});


			this.add_events(EventMask.KEY_PRESS_MASK);
			this.key_press_event.connect( (event_key) => {
				switch (event_key.keyval) {
					case Gdk.Key.Up:
						break;
					case Gdk.Key.Right:
						break;
					case Gdk.Key.Down:
						break;
					case Gdk.Key.Left:
						break;
					case Gdk.Key.Return:
						selected(selection);
						Gtk.main_quit();
						break;
					case Gdk.Key.space:
						selected(selection);
						Gtk.main_quit();
						break;
					case Gdk.Key.Escape:
						selected(null);
						Gtk.main_quit();
						break;
					default:
						selected(null);
						Gtk.main_quit();
						break;
				}
				return true;
			});

			show_all();
			gwin = this.get_toplevel().get_window();
		}

		public Gdk.Rectangle? run() {
			show_all();
			present();
			Gtk.main();
			/* destroy(); */
			return selection;
		}

		private bool is_near(int x1, int y1, int x2, int y2, int radius) {

			int r = radius / 2;

			return
				x1 >= x2 - r &&
				x1 <= x2 + r &&
				y1 >= y2 - r &&
				y1 <= y2 + r
			;
		}


		protected bool on_draw(Context ctx) {

			int width, height;
			get_size(out width, out height);
			ctx.set_source_rgba(0.1, 0.1, 0.1, 0.5);
			ctx.rectangle(0, 0, width, selection.y);
			ctx.fill();
			ctx.rectangle(0, selection.y + selection.height, width, height - selection.height - selection.y);
			ctx.fill();
			ctx.rectangle(0, selection.y,  selection.x, selection.height);
			ctx.fill();
			ctx.rectangle(selection.x + selection.width, selection.y,  width - selection.x - selection.width, selection.height);
			ctx.fill();

			return true;
		}
	}
}

