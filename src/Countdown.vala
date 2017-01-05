namespace Capture {

	public class Countdown {

		public int seconds { get; set; }
		protected int timer;

		public signal void tick(int second, double progress);
		public signal void ignition();

		public Countdown(int seconds) {
			this.seconds = seconds;
		}

		public void start() {

			timer = seconds;

			if (timer == 0) {
				ignition();
				return;
			}

			Timeout.add_seconds(1, () => {
				timer--;
				tick(timer, (double)(seconds - timer) / (double)seconds);
				if (timer <= 0) {
					ignition();
					return false;
				}
				return true;
			}, Priority.DEFAULT);
		}
	}
}
