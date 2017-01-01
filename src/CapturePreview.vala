namespace Capture {

	public class CapturePreview : Gtk.Dialog {

		public Sequence sequence;
		private Gtk.Image image;

		public CapturePreview(Sequence sequence) {
			this.sequence = sequence;

			this.title = "Preview";
			create_widgets();
			connect_signals();

			run_sequence();
		}

		private void create_widgets() {

			image = new Gtk.Image();
			var content_area = get_content_area();
			content_area.pack_start(image, true, true, 0);

			add_button("Close", Gtk.ResponseType.CLOSE);

			show_all();
		}

		private void connect_signals() {
		}

		public void run_sequence() {

			Timeout.add(50, () => {
				image.pixbuf = sequence.next();
				return true;
			});
		}
	}
}
