using Gtk;
using Plank;

namespace Capture {

	public class CapturePreview : Gtk.Dialog {

		public Sequence sequence;
		private uint sequence_length;
		private Image image;
		private bool playing = false;
		private Button play_button;
		private Button next_button;
		private Button prev_button;
		private ProgressBar progress_bar;
		

		public CapturePreview(Sequence sequence) {
			this.sequence = sequence;
			sequence_length = sequence.length();

			this.title = "Preview";
			set_default_size(
				sequence.first().get_width().clamp(500, 1000), 
				sequence.first().get_height().clamp(400, 800)
			);
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

			progress_bar = new ProgressBar();
			progress_bar.set_show_text(true);
			content_area.pack_start(progress_bar, false, false, 0);
			
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
			add_button("Save", ResponseType.ACCEPT);

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
					update_progress_bar();
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
			update_progress_bar();
		}

		private void on_next_button_clicked() {
			image.pixbuf = sequence.next();
			update_progress_bar();
		}

		private void update_progress_bar() {
			progress_bar.set_fraction((double)sequence.frame / (double)sequence_length);
			progress_bar.set_text("%u/%u".printf(sequence.frame, sequence_length));
		}

	}
}
