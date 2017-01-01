using Gdk;

namespace Capture {

	public class Sequence {



		protected List<Pixbuf> pixbufs;
		protected uint frame;
		public uint framerate {get; set; }



		public Sequence() {
			pixbufs = new List<Pixbuf>();
			frame = 0;
		}



		public void add(Pixbuf pixbuf) {
			pixbufs.append(pixbuf);	
		}



		public uint length() {
			return pixbufs.length();
		}



		public Pixbuf? first() {

			assert (pixbufs.length() > 0);

			return pixbufs.nth_data(0);
		}


			
		public Pixbuf? next() {

			assert (pixbufs.length() > 0);

			if (++frame >= length()) {
				frame = 0;
			}
			return pixbufs.nth_data(frame);
		}



		public Pixbuf? previous() {

			assert (pixbufs.length() > 0);

			if (frame == 0) {
				frame = pixbufs.length() - 1;
			}
			else {
				frame--;
			}
			return pixbufs.nth_data(frame);
		}
	}
}

