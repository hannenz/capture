using Gtk;
using Plank;

namespace Capture {

	public class CapturePreview : Gtk.Dialog {

		public Sequence sequence;
		private Image image;
		private bool playing = false;
		private Button play_button;
		private Button next_button;
		private Button prev_button;
		

		public CapturePreview(Sequence sequence) {
			this.sequence = sequence;

			this.title = "Preview";
			create_widgets();
			connect_signals();

			run_sequence();
		}

		private void create_widgets() {

			image = new Image();
			image.pixbuf = sequence.first();
			var content_area = get_content_area();

			var swin = new ScrolledWindow(null, null);
			swin.add(image);
			content_area.pack_start(swin, true, true, 0);

			var button_box = new ButtonBox(Orientation.HORIZONTAL);
			button_box.set_layout(ButtonBoxStyle.CENTER);
			prev_button = new Button.with_label("<");
			button_box.pack_start(prev_button, true, false, 0);
			play_button = new Button.with_label("Play");
			button_box.pack_start(play_button, true, false, 0);
			next_button = new Button.with_label(">");
			button_box.pack_start(next_button, true, false, 0);

			content_area.pack_start(button_box, false, false, 0);
			add_button("Close", ResponseType.CLOSE);

			show_all();
		}

		private void connect_signals() {
			play_button.clicked.connect(on_play_button_clicked);
			prev_button.clicked.connect(on_prev_button_clicked);
			next_button.clicked.connect(on_next_button_clicked);
		}

		public void run_sequence() {

			Timeout.add(1000 / sequence.framerate, () => {
				if (playing == true) {
					image.pixbuf = sequence.next();
				}
				return true;
			});
		}

		private void on_play_button_clicked(Button button) {
			playing = !playing;
			button.set_label(playing ? "Pause" : "Play");
		}

		private void on_prev_button_clicked() {
			image.pixbuf = sequence.previous();
		}

		private void on_next_button_clicked() {
			image.pixbuf = sequence.next();
		}
	}
}
