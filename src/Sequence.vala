using Gdk;

namespace Capture {

	public class Sequence {

		protected List<Pixbuf> pixbufs;


		public Sequence() {
			pixbufs = new List<Pixbuf>();
		}

		public void add(Pixbuf pixbuf) {
			pixbufs.append(pixbuf);	
		}

		public int length() {
			return pixbufs.length();
		}
	}
}

