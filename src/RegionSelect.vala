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

	/* public class RegionSelect : Granite.Widgets.CompositedWindow { */
	public class RegionSelect : Gtk.Window {

		protected Gtk.DrawingArea drawing_area;
		protected Gdk.RGBA fgcol;
		protected Gdk.RGBA bgcol;
		protected Gdk.RGBA white;
		protected Gdk.Device mouse;
		protected Gdk.Window gwin;

		private DragStatus status;
		private int delta_x;
		private int delta_y;

		public Gdk.Rectangle selection;
		
		public RegionSelect() {


			Logger.notification("RegionSelect() constructor");

			selection = Gdk.Rectangle();
			selection.x = 100;
			selection.y = 100;
			selection.width = 200;
			selection.height = 150;
			
			fgcol.red = 0.9;
			fgcol.green = 0;
			fgcol.blue = 0;
			fgcol.alpha = 1.0;
			bgcol.red = bgcol.green = bgcol.blue = 0.2;
			bgcol.alpha = 0.5;
			white.red = white.green = white.blue = white.alpha = 1.0;

			drawing_area = new Gtk.DrawingArea();
			drawing_area.draw.connect(on_draw);
			drawing_area.add_events(Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.BUTTON_MOTION_MASK | Gdk.EventMask.BUTTON1_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
			
			add(drawing_area);
			fullscreen();
			set_modal(true);

			var screen = Gdk.Screen.get_default();
			set_default_size(screen.get_width(), screen.get_height());
			resize(screen.get_width(), screen.get_height());

			var display = Display.get_default();
			var manager = display.get_device_manager();
			mouse = manager.get_client_pointer();

			status = DragStatus.NONE;

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
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "nw-resize"));
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y, 30)) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "ne-resize"));
				}
				else if (is_near(x, y, selection.x + selection.width, selection.y + selection.height, 30)) {  
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "se-resize"));
				}
				else if (is_near(x, y, selection.x, selection.y + selection.height, 30)) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "sw-resize"));
				}
				else if (x >= selection.x && x < selection.x + selection.width && y > selection.y && y < selection.y + selection.height) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "move"));
				}
				else if (x >= selection.x - 15 && x <= selection.x + 15) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "w-resize"));
				}
				else if (x >= selection.x + selection.width - 15 && x <= selection.x + selection.width + 15) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "e-resize"));
				}
				else if (y >= selection.y + selection.height - 15 && y <= selection.y + selection.height + 15) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "s-resize"));
				}
				else if (y >= selection.y - 15 && y <= selection.y + 15) {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "n-resize"));
				}

				else {
					gwin.set_cursor(new Gdk.Cursor.from_name(display, "pointer"));
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
						/* selection.x += x - selection.x; */
						/* selection.y += y - selection.y; */
						selection.x = x - delta_x;
						selection.y = y - delta_y;
						break;
					case DragStatus.NORTH:
						Logger.notification("Going NORTH");
						/* selection.height = selection.y + selection.height - y; */
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
						/* selection.width = selection.x + selection.width - x; */
						selection.width += selection.x - x;
						selection.x = x;
						break;

				}

				/* Logger.notification("%d %d %d %d".printf(selection.x, selection.y, selection.width, selection.height)); */


				if (status != DragStatus.NONE) {
					/* selection.width = x - selection.x; */
					/* selection.height = y - selection.y; */
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


			int width, height;
			get_size(out width, out height);
			Logger.notification("%ux%u".printf(width, height));

			show_all();
			gwin = this.get_toplevel().get_window();
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

			/* Pattern pat = new Pattern.rgba(0.2, 0.2, 0.2, 0.5); */

			ctx.rectangle(selection.x, selection.y, selection.width, selection.height);
			ctx.clip();
			ctx.new_path();

			int width, height;
			get_size(out width, out height);
			Gdk.cairo_set_source_rgba(ctx, bgcol);
			ctx.rectangle(0, 0, width, height);
			ctx.fill();
			return true;

			// Draw overlay rectangle (full window dimensions)
			/* int width, height; */
			/* get_size(out width, out height); */
			/* Gdk.cairo_set_source_rgba(ctx, bgcol); */
			/* ctx.rectangle(0, 0, width, height); */
			/* ctx.fill(); */
            /*  */
			/* Gdk.cairo_set_source_rgba(ctx, fgcol); */
			/* ctx.rectangle(selection.x, selection.y, selection.width, selection.height); */
			/* ctx.stroke(); */
            /*  */
			/* Gdk.cairo_set_source_rgba(ctx, white); */
			/* ctx.rectangle(selection.x, selection.y, selection.width, selection.height); */
			/* ctx.fill(); */
			/*  */
			/* return true; */
		}
	}
}

