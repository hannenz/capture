using Gtk;

namespace Capture {

	public class SettingsDialog : Gtk.Dialog {

		protected GLib.Settings settings;
		protected Gtk.SpinButton countdown_spin_button;

		public SettingsDialog() {
		
			settings = new GLib.Settings("de.hannenz.capture");

			create_widgets();
			connect_signals();
		}

		private void create_widgets() {
			var content_area = get_content_area();
			var grid = new Gtk.Grid();
			content_area.pack_start(grid);

			grid.attach(new Label("Countdown"), 0, 0, 1, 1);
			add_button("Close", ResponseType.CLOSE);
			countdown_spin_button = new SpinButton.with_range(0, 100, 1);
			countdown_spin_button.set_value((double)settings.get_int("countdown"));
			grid.attach(countdown_spin_button, 1, 0, 1, 1);

			show_all();
		}

		private void connect_signals() {
			return;
		}
	}
}
