using Gtk;
using Granite.Widgets;

namespace Capture {

	public class SettingsDialog : Gtk.Dialog {

		protected GLib.Settings settings;
		protected Gtk.SpinButton countdown_spin_button;
		protected Gtk.SpinButton framerate_spin_button;
		protected Gtk.CheckButton include_pointer_checkbutton;
		protected Gtk.CheckButton auto_save_checkbutton;
		protected Granite.Widgets.ModeButton file_format_mode_button;
		

		public SettingsDialog() {
		
			settings = new GLib.Settings("de.hannenz.capture");
			settings.changed.connect(on_setting_has_changed);

			title = "Settings";
			border_width = 10;

			create_widgets();
			connect_signals();
		}

		private void create_widgets() {
			var content_area = get_content_area();
			var grid = new Gtk.Grid();

			grid.set_row_spacing(10);
			grid.set_column_spacing(10);

			content_area.pack_start(grid);

			add_button("Close", ResponseType.CLOSE);

			grid.attach(new Label("Countdown"), 0, 0, 1, 1);
			countdown_spin_button = new SpinButton.with_range(0, 100, 1);
			countdown_spin_button.set_value((double)settings.get_int("countdown"));
			grid.attach(countdown_spin_button, 1, 0, 1, 1);

			grid.attach(new Label("Framerate"), 0, 1, 1, 1);
			framerate_spin_button = new SpinButton.with_range(1, 30, 1);
			framerate_spin_button.set_value((double)settings.get_int("framerate"));
			grid.attach(framerate_spin_button, 1, 1, 1, 1);

			include_pointer_checkbutton = new CheckButton.with_label("Include pointer");
			include_pointer_checkbutton.set_active(settings.get_boolean("include-pointer"));
			grid.attach(include_pointer_checkbutton, 1, 2, 1, 1);

			auto_save_checkbutton = new CheckButton.with_label("Auto save");
			auto_save_checkbutton.set_active(settings.get_boolean("auto-save"));
			grid.attach(auto_save_checkbutton, 1, 3, 1, 1);

			grid.attach(new Label("File format"), 0, 4, 1, 1);
			file_format_mode_button = new ModeButton();
			file_format_mode_button.append_text("PNG");
			file_format_mode_button.append_text("JPG");
			file_format_mode_button.append_text("GIF");
			switch(settings.get_string("file-format")) {
				case "png": file_format_mode_button.set_active(0); break;
				case "jpg": file_format_mode_button.set_active(1); break;
				case "gif": file_format_mode_button.set_active(3); break;
			}
			grid.attach(file_format_mode_button, 1, 4, 1, 1);

			show_all();
		}

		private void connect_signals() {
			countdown_spin_button.changed.connect( () => {
				settings.set_int("countdown", (int)countdown_spin_button.get_value());
			});
			framerate_spin_button.changed.connect( () => {
				settings.set_int("framerate", (int)framerate_spin_button.get_value());
			});
			include_pointer_checkbutton.toggled.connect( () => {
				settings.set_boolean("include-pointer", include_pointer_checkbutton.get_active());
			});
			auto_save_checkbutton.toggled.connect( () => {
				settings.set_boolean("auto-save", auto_save_checkbutton.get_active());
			});
		}

		private void on_setting_has_changed(string key) {

			switch (key) {
				case "countdown":
					countdown_spin_button.set_value((double)settings.get_int("countdown"));
					break;
				case "framerate":
					framerate_spin_button.set_value((double)settings.get_int("framerate"));
					break;
				case "include-pointer":
					include_pointer_checkbutton.set_active(settings.get_boolean("include-pointer"));
					break;
				case "auto-save":
					auto_save_checkbutton.set_active(settings.get_boolean("auto-save"));
					break;
				case "file-format":
					int i = 0;
					switch (settings.get_string("file-format")) {
						case "png": i = 0; break;
						case "jpg": i = 1; break;
						case "gif": i = 2; break;
					}

					file_format_mode_button.set_active(i);
					break;

			}

		}
	}
}
