using Gdk;

namespace Capture {

	public class Sequence {

		protected List<Pixbuf> pixbufs;

		protected uint frame;

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

		public Pixbuf? next() {
			var pixbuf = pixbufs.nth_data(frame);
			if (++frame >= length()) {
				frame = 0;
			}
			return pixbuf;
		}
	}
}

